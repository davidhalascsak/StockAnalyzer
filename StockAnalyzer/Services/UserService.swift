import Foundation
import FirebaseFirestore

struct UserService {
    private var db = Firestore.firestore().collection("users")
    
    func fetchUsers(completion: @escaping ([User]) -> Void) {
        var users = [User]()
        
        db.getDocuments { snapshot, _ in
            guard let snapshot = snapshot else {return}
            
            users = snapshot.documents.compactMap({try? $0.data(as: User.self)})
            completion(users)
        }
    }
    
    func fetchUserFromReference(ref: DocumentReference?, completion: @escaping (User) -> Void) {
        ref?.getDocument { snapshot, error in
            guard let snapshot = snapshot else {return}
            
            
            
            
            guard let user = try? snapshot.data(as: User.self) else {return}
            completion(user)
        }
    }
}
