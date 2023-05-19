import Foundation
import CoreData
import FirebaseAuth
import FirebaseFirestore

class PortfolioService: ObservableObject, PortfolioServiceProtocol {
    private var db = Firestore.firestore()
    
    func fetchAssets() async -> [Asset]  {
        var assets: [Asset] = []
        
        if let userId = Auth.auth().currentUser?.uid {
            let snapshot = try? await db.collection("users").document(userId).collection("assets").getDocuments()
            if let snapshot = snapshot {
                assets = snapshot.documents.compactMap({try? $0.data(as: Asset.self)})
                for index in 0..<assets.count {
                    assets[index].positions = await fetchPositions(symbol: assets[index].stockSymbol)
                }
            }
        }
        
        return assets.sorted(by: {$0.investedAmount < $1.investedAmount})
    }
    
    func fetchPositions(symbol: String) async -> [Position] {
        if let userId = Auth.auth().currentUser?.uid {
            let snapshot = try? await db.collection("users").document(userId).collection("assets").document(symbol)
                .collection("positions").getDocuments()
            if let snapshot = snapshot {
                return snapshot.documents.compactMap({try? $0.data(as: Position.self)})
            }
        }
        return []
    }
    
    func addPosition(symbol: String, position: Position) async -> Bool {
        let newPosition = ["date": position.date, "units": position.units, "price": position.price] as [String : Any]
        
        if let userId = Auth.auth().currentUser?.uid {
            let asset = try? await db.collection("users").document(userId).collection("assets").document(symbol).getDocument(as: Asset.self)
            
            let newUnits = (asset?.units ?? 0.0) + position.units
            let newAmount = (asset?.investedAmount ?? 0.0) + (position.units * position.price)
            let newAveragePrice = newAmount / newUnits
            let newPositionCount = (asset?.positionCount ?? 0) + 1
            
            let newAsset = ["stockSymbol": symbol,  "units": newUnits, "averagePrice": newAveragePrice, "positionCount": newPositionCount] as [String : Any]
            
            do {
                try await self.db.collection("users").document(userId).collection("assets").document(symbol).setData(newAsset)
                let _ = try await db.collection("users").document(userId).collection("assets").document(symbol).collection("positions").addDocument(data: newPosition)
                return true
            } catch {
                return false
            }
        }
        return false
    }
    
    func deleteAsset(symbol: String) async -> Bool {
        if let userId = Auth.auth().currentUser?.uid {
            let assetPath = db.collection("users").document(userId).collection("assets").document(symbol)
            
            do {
                let snapshot = try? await assetPath.collection("positions").getDocuments()
                
                if let snapshot = snapshot {
                    let _ = snapshot.documents.compactMap({
                        assetPath.collection("positions").document($0.reference.documentID).delete()
                    })
                }
                
                try await assetPath.delete()
                
                return true
            } catch{
                return false
            }
        }
        return false
    }
    
    func deletePosition(asset: Asset, position: Position) async -> Bool {
        if let userId = Auth.auth().currentUser?.uid {
            let assetPath = db.collection("users").document(userId).collection("assets").document(asset.stockSymbol)
            
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
                        try await db.collection("users").document(userId).collection("assets").document(asset.stockSymbol).delete()
                    } else {
                        try await db.collection("users").document(userId).collection("assets").document(asset.stockSymbol).updateData(["positionCount": newPositionCount])
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
    var db: MockDatabase = MockDatabase()
    
    func fetchAssets() async -> [Asset]  {
        for index in 0..<db.assets.count {
            db.assets[index].positions = await fetchPositions(symbol: db.assets[index].stockSymbol)
        }
        
        return db.assets
    }
    
    func addPosition(symbol: String, position: Position) async -> Bool {
        let newPosition = Position(date: position.date, units: position.units, price: position.price)
        
        let asset = db.assets.first(where: {$0.stockSymbol == symbol})
        
        let newUnits = (asset?.units ?? 0.0) + position.units
        let newAmount = (asset?.investedAmount ?? 0.0) + (position.units * position.price)
        let newAveragePrice = newAmount / newUnits
        let newPositionCount = (asset?.positionCount ?? 0) + 1
        
        let newAsset = Asset(stockSymbol: symbol, units: newUnits, averagePrice: newAveragePrice, positionCount: newPositionCount)
        
        db.assets.removeAll(where: {$0.stockSymbol == symbol})
        db.assets.append(newAsset)
        db.positions[symbol]?.append(newPosition)
        
        return true
    }
    
    func fetchPositions(symbol: String) async -> [Position] {
        if symbol == "" {
            return []
        } else {
            return db.positions[symbol] ?? []
        }
    }
    
    func deleteAsset(symbol: String) async -> Bool {
        db.assets.removeAll(where: {$0.stockSymbol == symbol})
        
        return true
    }
    
    func deletePosition(asset: Asset, position: Position) async -> Bool {
        db.assets.removeAll(where: {$0.stockSymbol == asset.stockSymbol})
        
        if asset.positionCount > 1 {
            let investedAmount = asset.investedAmount - position.investedAmount
            let units = asset.units - position.units
            let averagePrice = investedAmount / units
            
            let newAsset = Asset(stockSymbol: asset.stockSymbol, units: units, averagePrice: averagePrice, positionCount: asset.positionCount - 1)
            
            
            db.assets.append(newAsset)
        }
        return true
    }
}

protocol PortfolioServiceProtocol {
    func fetchAssets() async -> [Asset]
    func fetchPositions(symbol: String) async -> [Position]
    func addPosition(symbol: String, position: Position) async -> Bool
    func deleteAsset(symbol: String) async -> Bool
    func deletePosition(asset: Asset, position: Position) async -> Bool
}
