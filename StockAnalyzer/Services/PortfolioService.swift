import Foundation
import CoreData
import FirebaseAuth
import FirebaseFirestore

class PortfolioService: ObservableObject, PortfolioServiceProtocol {
    private var db = Firestore.firestore()
    
    func fetchAssets() async -> [Asset]  {
        var assets: [Asset] = []
        
        if let userId = Auth.auth().currentUser?.uid {
            let snapshot = try? await db.collection("users").document(userId).collection("portfolio").order(by: "investedAmount", descending: true).getDocuments()
            if let snapshot = snapshot {
                assets = snapshot.documents.compactMap({try? $0.data(as: Asset.self)})
                for index in 0..<assets.count {
                    assets[index].positions = await fetchPositions(symbol: assets[index].symbol)
                }
            }
        }
        
        return assets
    }
    
    func fetchPositions(symbol: String) async -> [Position] {
        var positions: [Position] = []
        
        if let userId = Auth.auth().currentUser?.uid {
            let snapshot = try? await db.collection("users").document(userId).collection("portfolio").document(symbol)
                .collection("positions").getDocuments()
            if let snapshot = snapshot {
                positions = snapshot.documents.compactMap({try? $0.data(as: Position.self)})
            }
        }
        
        return positions
    }
    
    func addPosition(position: Position) async {
        let newPosition = ["symbol": position.symbol, "date": position.date, "units": position.units, "price": position.price,
                        "investedAmount": position.investedAmount] as [String : Any]
        
        if let userId = Auth.auth().currentUser?.uid {
            let portfolio = try? await db.collection("users").document(userId).collection("portfolio").document(position.symbol).getDocument(as: Asset.self)
            
            let newUnits = (portfolio?.units ?? 0.0) + position.units
            let newAmount = (portfolio?.investedAmount ?? 0.0) + (position.units * position.price)
            let newAveragePrice = newAmount / newUnits
            let newPositionCount = (portfolio?.positionCount ?? 0) + 1
            
            let newPortfolio = ["symbol": position.symbol, "units": newUnits, "averagePrice": newAveragePrice, "investedAmount": newAmount, "positionCount": newPositionCount] as [String : Any]
            
            do {
                try await self.db.collection("users").document(userId).collection("portfolio").document(position.symbol).setData(newPortfolio)
                let _ = try await self.db.collection("users").document(userId).collection("portfolio").document(position.symbol).collection("positions").addDocument(data: newPosition)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteAsset(symbol: String) async -> Bool {
        if let userId = Auth.auth().currentUser?.uid {
            do {
                let snapshot = try? await db.collection("users").document(userId).collection("portfolio").document(symbol).collection("positions").getDocuments()
                
                if let snapshot = snapshot {
                    let _ = snapshot.documents.compactMap({ $0.reference.delete })
                }
                try await db.collection("users").document(userId).collection("portfolio").document(symbol).delete()
                
                return true
            } catch{
                return false
            }
        }
        
        return false
    }
    
    func deletePosition(asset: Asset, position: Position) async -> Bool {
        if let userId = Auth.auth().currentUser?.uid {
            let assetPath = db.collection("users").document(userId).collection("portfolio").document(asset.symbol)
            
            if let id = position.id {
                do {
                    let asset = try await assetPath.getDocument(as: Asset.self)
                    
                    let investedAmount = asset.investedAmount - position.investedAmount
                    let units = asset.units - position.units
                    let averagePrice = investedAmount / units
                    
                    try await assetPath.updateData(["investedAmount": investedAmount, "units": units, "averagePrice": averagePrice])
                    try await assetPath.collection("positions").document(id).delete()
                    
                    let newPositionCount = asset.positionCount - 1
                    
                    if newPositionCount == 0 {
                        try await db.collection("users").document(userId).collection("portfolio").document(asset.symbol).delete()
                    } else {
                        try await db.collection("users").document(userId).collection("portfolio").document(asset.symbol).updateData(["positionCount": newPositionCount])
                    }
                    return true
                } catch {
                    return true
                }
            }
        }
        return false
    }
}

class MockPortfolioService: PortfolioServiceProtocol {
    var assets: [Asset] = []
    var positions: [Position] = []
    
    init() {
        let asset1 = Asset(symbol: "AAPL", units: 2.0, averagePrice: 132.5, investedAmount: 265.0, positionCount: 1)
        let asset2 = Asset(symbol: "MSFT", units: 3.0, averagePrice: 230.0, investedAmount: 690.0, positionCount: 1)
        
        self.assets.append(contentsOf: [asset1, asset2])
        
        let position1 = Position(symbol: "AAPL", date: "2023-02-02", units: 1, price: 132.5, investedAmount: 132.5)
        let position2 = Position(symbol: "AAPL", date: "2023-01-02", units: 1, price: 132.5, investedAmount: 132.5)
        let position3 = Position(symbol: "MSFT", date: "2020-02-02", units: 3.0, price: 230.0, investedAmount: 690.0)
        
        self.positions.append(contentsOf: [position1, position2, position3])
    }
    
    func fetchAssets() async -> [Asset]  {
        for index in 0..<self.assets.count {
            self.assets[index].positions = await fetchPositions(symbol: self.assets[index].symbol)
        }
        
        return self.assets
    }
    
    func addPosition(position: Position) async {
        
    }
    
    func fetchPositions(symbol: String) async -> [Position] {
        if symbol == "" {
            return []
        } else {
            return self.positions.filter({$0.symbol == symbol})
        }
    }
    
    func deleteAsset(symbol: String) async -> Bool {
        assets.removeAll(where: {$0.symbol == symbol})
        
        return true
    }
    
    func deletePosition(asset: Asset, position: Position) async -> Bool {
        self.assets.removeAll(where: {$0.symbol == asset.symbol})
        
        if asset.positionCount > 1 {
            let investedAmount = asset.investedAmount - position.investedAmount
            let units = asset.units - position.units
            let averagePrice = investedAmount / units
            
            let newAsset = Asset(symbol: asset.symbol, units: units, averagePrice: averagePrice, investedAmount: investedAmount, positionCount: 1)
            
            
            self.assets.append(newAsset)
        }
        
        return true
    }
}

protocol PortfolioServiceProtocol {
    func fetchAssets() async -> [Asset]
    func fetchPositions(symbol: String) async -> [Position]
    func addPosition(position: Position) async
    func deleteAsset(symbol: String) async -> Bool
    func deletePosition(asset: Asset, position: Position) async -> Bool
}
