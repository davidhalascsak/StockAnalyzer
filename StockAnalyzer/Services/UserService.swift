import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserService {
    private var db = Firestore.firestore()
    private let locale = Locale(identifier: "en-US")

    func fetchAllUser() async -> [User] {
        var users = [User]()
        
        let snapshot = try? await db.collection("users").getDocuments()
        guard let snapshot = snapshot else {return []}
            
        users = snapshot.documents.compactMap({try? $0.data(as: User.self)})
        return users
    }
    
    func fetchUser(id: String) async -> User? {
        let snapshot = try? await db.collection("users").document(id).getDocument()
        guard let snapshot = snapshot else {return nil}
        
        let user = try? snapshot.data(as: User.self)
        return user
    }
    
    func createUser(user: User) async throws {
        let data = ["username": user.username, "email": user.email, "location": user.location]
        
        try await db.collection("users").document(user.id ?? "").setData(data)
    }
}
