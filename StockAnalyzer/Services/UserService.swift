import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserService {
    private var db = Firestore.firestore()
    private let locale = Locale(identifier: "en-US")

    func fetchAllUser() async -> [User] {
        var users = [User]()
        
        do {
            let snapshot = try await db.collection("users").getDocuments()
            users = snapshot.documents.compactMap({try? $0.data(as: User.self)})  
        } catch {
            
        }
        return users
    }
    
    func fetchUser(id: String, completion: @escaping (User?) -> Void) {
        db.collection("users").document(id).getDocument { snapshot, error in
            guard let snapshot = snapshot else {return}
            let user = try? snapshot.data(as: User.self)
            completion(user)
        }
    }
    
    func createUser(user: User) async throws {
        let data = ["username": user.username, "email": user.email, "location": user.location]
        
        try await db.collection("users").document(user.id ?? "").setData(data)
    }
}
