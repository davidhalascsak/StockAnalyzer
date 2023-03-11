import Foundation
import FirebaseFirestore
import FirebaseAuth

class CommentService: ObservableObject {
    private var db = Firestore.firestore()
    @Published var isUpdated: Bool = true
    
    func fetchComments(post: Post, completion: @escaping (([Comment]) -> Void)) {
        guard let postId = post.id else {return}
        var comments: [Comment]  = []
        
        db.collection("posts").document(postId).collection("comments").order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                guard let snapshot = snapshot else {return}
                
                comments = snapshot.documents.compactMap({try? $0.data(as: Comment.self)})
                completion(comments)
            }
    }
    
    func checkIfCommentIsLiked(comment: Comment, completion: @escaping ((Bool) -> Void)) {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        guard let commentId = comment.id else {return}
        db.collection("users").document(userId).collection("likedComments").document(commentId).getDocument { snapshot, error in
            guard let snapshot = snapshot else {return}
            completion(snapshot.exists)
        }
    }
    
    func likeComment(post: Post, comment: Comment, completion: @escaping (() -> Void)) {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        guard let postId = post.id else {return}
        guard let commentId = comment.id else {return}
        
        let likedComments = db.collection("users").document(userId).collection("likedComments")
        
        db.collection("posts").document(postId).collection("comments").document(commentId).getDocument(as: Comment.self) { result in
            guard let data = try? result.get() else {return}
            self.db.collection("posts").document(postId).collection("comments").document(commentId).updateData(["likes": data.likes + 1]) { _ in
                likedComments.document(commentId).setData([:]) { _ in
                    self.isUpdated = true
                    completion()
                }
            }
        }
    }
    
    
    func unlikeComment(post: Post, comment: Comment, completion: @escaping (() -> Void)) {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        guard let postId = post.id else {return}
        guard let commentId = comment.id else {return}
        
        let likedComments = db.collection("users").document(userId).collection("likedComments")
        
        db.collection("posts").document(postId).collection("comments").document(commentId).getDocument(as: Comment.self) { result in
            guard let data = try? result.get() else {return}
            self.db.collection("posts").document(postId).collection("comments").document(commentId).updateData(["likes": data.likes - 1]) { _ in
                likedComments.document(commentId).delete() { _ in
                    self.isUpdated = true
                    completion()
                }
            }
        }
    }
    
    func createComment(post: Post, body: String, completion: @escaping (() -> Void)) {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        guard let postId = post.id else {return}
        let newData = ["body": body, "likes": 0, "userRef": userId, "timestamp": Timestamp(date: Date())] as [String : Any]
        
        
        db.collection("posts").document(postId).getDocument(as: Post.self) { result in
            guard let data = try? result.get() else {return}
            self.db.collection("posts").document(postId).updateData(["comments": data.comments + 1]) { _ in
                self.db.collection("posts").document(postId).collection("comments").addDocument(data: newData) {_ in
                    completion()
                }
            }
        }
    }
}
