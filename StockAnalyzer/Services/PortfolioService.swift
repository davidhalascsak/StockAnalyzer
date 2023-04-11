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

protocol PortfolioServiceProtocol {
    func fetchAssets() async -> [Asset]
    func fetchPositions(symbol: String) async -> [Position]
    func deleteAsset(symbol: String) async
}
