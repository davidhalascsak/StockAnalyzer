import Foundation
import FirebaseFirestore
import FirebaseAuth
import Firebase

class PostService: ObservableObject {
    private var db = Firestore.firestore()
    @Published var isUpdated: Bool = true
    
    func fetchPosts(symbol: String?, completion: @escaping ([Post]) -> Void) {
        var posts = [Post]()
        
        if let symbol = symbol {
            db.collection("posts").whereField("symbol", isEqualTo: symbol).order(by: "timestamp", descending: true)
                .getDocuments { snapshot, error in
                    guard let snapshot = snapshot else {return}
                    
                    posts = snapshot.documents.compactMap({try? $0.data(as: Post.self)})
                    completion(posts)
                }
        } else {
            db.collection("posts").order(by: "timestamp", descending: true)
                .getDocuments { snapshot, error in
                    guard let snapshot = snapshot else {return}
                    
                    posts = snapshot.documents.compactMap({try? $0.data(as: Post.self)})
                    completion(posts)
                }
        }
    }
    
    func checkIfPostIsLiked(post: Post, completion: @escaping ((Bool) -> Void)) {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        guard let postId = post.id else {return}
        db.collection("users").document(userId).collection("likedPosts").document(postId).getDocument { snapshot, error in
            guard let snapshot = snapshot else {return}
            completion(snapshot.exists)
        }
    }
    
    func likePost(post: Post, completion: @escaping (() -> Void)) {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        guard let postId = post.id else {return}
        
        let likedPosts = db.collection("users").document(userId).collection("likedPosts")
        
        db.collection("posts").document(postId).getDocument(as: Post.self) { result in
            guard let data = try? result.get() else {return}
            self.db.collection("posts").document(postId).updateData(["likes": data.likes + 1]) { _ in
                likedPosts.document(postId).setData([:]) { _ in
                    self.isUpdated = true
                    completion()
                }
            }
        }
    }
    
    func unlikePost(post: Post, completion: @escaping (() -> Void)) {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        guard let postId = post.id else {return}
        
        let likedPosts = db.collection("users").document(userId).collection("likedPosts")
        
        db.collection("posts").document(postId).getDocument(as: Post.self) { result in
            guard let data = try? result.get() else {return}
            self.db.collection("posts").document(postId).updateData(["likes": data.likes - 1]) { _ in
                likedPosts.document(postId).delete() { _ in
                    self.isUpdated = true
                    completion()
                }
            }
        }
    }
    
    func createPost(body: String, symbol: String?, completion: @escaping (() -> Void)) {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        
        if let symbol = symbol {
            let data = ["body": body, "likes": 0, "comments": 0, "userRef": userId, "timestamp": Timestamp(date: Date()), "symbol": symbol] as [String : Any]
            db.collection("posts").addDocument(data: data) {_ in
                completion()
            }
        } else {
            let data = ["body": body, "likes": 0, "comments": 0, "userRef": userId, "timestamp": Timestamp(date: Date()), "symbol": ""] as [String : Any]
            db.collection("posts").addDocument(data: data) {_ in
                completion()
            }
        }
    }
}
