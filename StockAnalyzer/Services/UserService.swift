import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserService {
    private var db = Firestore.firestore()
    private let locale = Locale(identifier: "en-US")

    func fetchAllUser(completion: @escaping ([User]) -> Void) {
        var users = [User]()
        
        db.collection("users").getDocuments { snapshot, error in
            guard let snapshot = snapshot else {return}
        
            users = snapshot.documents.compactMap({try? $0.data(as: User.self)})
            completion(users)
        }
    }
    
    func fetchUser(id: String, completion: @escaping (User?) -> Void) {
        db.collection("users").document(id).getDocument { snapshot, error in
            guard let snapshot = snapshot else {return}
            let user = try? snapshot.data(as: User.self)
            completion(user)
        }
    }
    
    func createUser(user: User, completion: @escaping (() -> Void)) {
        let data = ["username": user.username, "email": user.email, "location": user.location]
        
        db.collection("users").document(user.id ?? "").setData(data)
        completion()
    }
}
