import Foundation
import FirebaseFirestore

struct UserService {
    private var db = Firestore.firestore().collection("users")
    
    func fetchUsers(completion: @escaping ([User]) -> Void) {
        var users = [User]()
        
        db.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {return}
        
            users = snapshot.documents.compactMap({try? $0.data(as: User.self)})
            completion(users)
        }
    }
    
    func fetchUserFromReference(ref: DocumentReference?, completion: @escaping (User) -> Void) {
        if let ref = ref {
            ref.getDocument { snapshot, error in
                guard let snapshot = snapshot else {return}
                
                guard let user = try? snapshot.data(as: User.self) else {return}
                completion(user)
            }
        }
    }
    
    func fetchUserReference(email: String, completion: @escaping ((DocumentReference?) -> Void)) {
        let query = db.whereField("email", isEqualTo: email)
        query.getDocuments { snapshot, error in
            guard let snapshot = snapshot else {return}
            if snapshot.documents.count != 0 {
                completion(snapshot.documents[0].reference)
            } else {
                completion(nil)
            }
        }
    }
}
