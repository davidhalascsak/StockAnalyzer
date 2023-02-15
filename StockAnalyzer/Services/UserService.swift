import Foundation
import FirebaseAuth
import FirebaseFirestore

struct UserService {
    private var db = Firestore.firestore()
    
    func fetchAllUser(completion: @escaping ([User]) -> Void) {
        var users = [User]()
        
        db.collection("users").addSnapshotListener { snapshot, error in
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
    
    func updateLikes(post: Post) {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        guard let postId = post.id else {return}
        var isLiked = false
        var change = 0
        
        let likedPosts = db.collection("users").document(userId).collection("likedPosts")
        
        likedPosts.getDocuments { snapshot, error in
            snapshot?.documents.forEach({ snap in
                if snap.documentID == postId {
                    print("asd")
                    isLiked = true
                }
            })
            if isLiked {
                change = -1
            } else {
                change = 1
            }
            
            db.collection("posts").document(postId).updateData(["likes": post.likes + change]) { _ in
                if isLiked {
                    likedPosts.document(postId).delete()
                } else {
                    likedPosts.document(postId).setData([:])
                }
            }
        }
    }
}
