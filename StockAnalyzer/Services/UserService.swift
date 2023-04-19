import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserService: UserServiceProtocol {
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
        let data = ["username": user.username, "email": user.email, "location": user.location, "imageUrl": user.imageUrl]
        
        do {
            try await db.collection("users").document(user.id ?? "").setData(data)
        } catch let error {
            print(error)
        }
    }
}

protocol UserServiceProtocol {
    func fetchAllUser() async -> [User]
    func fetchUser(id: String) async -> User?
    func createUser(user: User) async throws
}
