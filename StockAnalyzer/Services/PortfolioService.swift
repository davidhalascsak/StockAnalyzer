import Foundation
import FirebaseAuth
import FirebaseFirestore

class PortfolioService: PortfolioServiceProtocol {
    private var db = Firestore.firestore()
    
    func fetchAssets() async -> [Asset]  {
        var assets: [Asset] = []
        
        if let userId = Auth.auth().currentUser?.uid {
            let snapshot = try? await db.collection("users").document(userId).collection("portfolio").getDocuments()
            if let snapshot = snapshot {
                assets = snapshot.documents.compactMap({try? $0.data(as: Asset.self)})
            }
        } else {
            print("Fetching from the phone's storage")
        }
        
        return assets
    }
}

protocol PortfolioServiceProtocol {
    func fetchAssets() async -> [Asset]
}
