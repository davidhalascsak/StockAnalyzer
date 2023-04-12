import Foundation
import FirebaseAuth
import FirebaseFirestore

class PortfolioService: PortfolioServiceProtocol {
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
        } else {
            print("Fetching from the phone's storage")
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
        } else {
            print("Fetching from the phone's storage")
        }
        
        return positions
    }
    
    func deleteAsset(symbol: String) async {
        if let userId = Auth.auth().currentUser?.uid {
            do {
                let snapshot = try? await db.collection("users").document(userId).collection("portfolio").document(symbol).collection("positions").getDocuments()
                
                if let snapshot = snapshot {
                    let _ = snapshot.documents.compactMap({ $0.reference.delete })
                }
                try await db.collection("users").document(userId).collection("portfolio").document(symbol).delete()
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            print("Deleting from the phone's storage")
        }
    }
}

class TestPortfolioService: PortfolioServiceProtocol {
    var assets: [Asset] = []
    
    init() {
        let asset1 = Asset(symbol: "AAPL", units: 2.0, averagePrice: 132.5, investedAmount: 265.0)
        let asset2 = Asset(symbol: "MSFT", units: 3.0, averagePrice: 230.0, investedAmount: 690.0)
        
        self.assets.append(asset1)
        self.assets.append(asset2)
    }
    
    func fetchAssets() async -> [Asset]  {
        for index in 0..<self.assets.count {
            self.assets[index].positions = await fetchPositions(symbol: self.assets[index].symbol)
        }
        
        return self.assets
    }
    
    func fetchPositions(symbol: String) async -> [Position] {
        let position1 = Position(symbol: "AAPL", date: "2020-02-02", units: 2.0, price: 132.5, investedAmount: 265.0)
        let position2 = Position(symbol: "MSFT", date: "2020-02-02", units: 3.0, price: 230.0, investedAmount: 690.0)
        
        if symbol == "AAPL" {
            return [position1]
        } else {
            return [position2]
        }
    }
    
    func deleteAsset(symbol: String) async {
        assets.removeAll(where: {$0.symbol == symbol})
    }
}

protocol PortfolioServiceProtocol {
    func fetchAssets() async -> [Asset]
    func fetchPositions(symbol: String) async -> [Position]
    func deleteAsset(symbol: String) async
}
