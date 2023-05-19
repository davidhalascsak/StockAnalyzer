import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserService: UserServiceProtocol {
    private var db = Firestore.firestore()

    func fetchAllUser() async -> [CurrentUser] {
        let snapshot = try? await db.collection("users").getDocuments()
        guard let snapshot = snapshot else {return []}
            
        return snapshot.documents.compactMap({try? $0.data(as: CurrentUser.self)})
    }
    
    func fetchUser(id: String) async -> CurrentUser? {
        let snapshot = try? await db.collection("users").document(id).getDocument()
        guard let snapshot = snapshot else {return nil}
        
        let user = try? snapshot.data(as: CurrentUser.self)
        return user
    }
    
    func createUser(user: CurrentUser) async throws {
        let data = ["username": user.username, "email": user.email, "location": user.country, "imageUrl": user.imageUrl]
        
        try await db.collection("users").document(user.id ?? "").setData(data)
    }
}

class MockUserService: UserServiceProtocol {
    var db: MockDatabase = MockDatabase()

    func fetchAllUser() async -> [CurrentUser] {
        return db.users
    }
    
    func fetchUser(id: String) async -> CurrentUser? {
        return db.users.first(where: {$0.id == id})
    }
    
    func createUser(user: CurrentUser) async throws {
        db.users.append(user)
    }
}

protocol UserServiceProtocol {
    func fetchAllUser() async -> [CurrentUser]
    func fetchUser(id: String) async -> CurrentUser?
    func createUser(user: CurrentUser) async throws
}
