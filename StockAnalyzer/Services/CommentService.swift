import Foundation
import FirebaseFirestore
import FirebaseAuth

class CommentService: ObservableObject, CommentServiceProtocol {
    @Published var isUpdated: Bool = true
    
    private var db = Firestore.firestore()
    
    func fetchComments(post: Post) async -> [Comment] {
        var comments: [Comment]  = []
        
        guard let postId = post.id else {return []}
        
        let snapshot = try? await db.collection("posts").document(postId).collection("comments").order(by: "timestamp", descending: true).getDocuments()
        guard let snapshot = snapshot else {return []}
        
        comments = snapshot.documents.compactMap({try? $0.data(as: Comment.self)})
        return comments
    }
    
    func checkIfCommentIsLiked(comment: Comment) async -> Bool {
        guard let userId = Auth.auth().currentUser?.uid else {return false}
        guard let commentId = comment.id else {return false}
        
        let snapshot = try? await db.collection("users").document(userId).collection("likedComments").document(commentId).getDocument()
        guard let snapshot = snapshot else {return false}
        
        return snapshot.exists
    }
    
    func likeComment(post: Post, comment: Comment) async {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        guard let postId = post.id else {return}
        guard let commentId = comment.id else {return}
        
        let likedComments = db.collection("users").document(userId).collection("likedComments")
        let fetchedComment = try? await db.collection("posts").document(postId).collection("comments").document(commentId).getDocument(as: Comment.self)
        
        guard let fetchedComment = fetchedComment else {return}
        
        do {
            try await self.db.collection("posts").document(postId).collection("comments").document(commentId).updateData(["likes": fetchedComment.likes + 1])
            try await likedComments.document(commentId).setData([:])
        } catch let error {
            print(error.localizedDescription)
        }
        self.isUpdated = true
    }
    
    func unlikeComment(post: Post, comment: Comment) async {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        guard let postId = post.id else {return}
        guard let commentId = comment.id else {return}
        
        let likedComments = db.collection("users").document(userId).collection("likedComments")
        let fetchedComment = try? await db.collection("posts").document(postId).collection("comments").document(commentId).getDocument(as: Comment.self)
        
        guard let fetchedComment = fetchedComment else {return}
        
        do {
            try await self.db.collection("posts").document(postId).collection("comments").document(commentId).updateData(["likes": fetchedComment.likes - 1])
            try await likedComments.document(commentId).delete()
        } catch let error {
            print(error.localizedDescription)
        }
        self.isUpdated = true
    }
    
    func createComment(post: Post, body: String) async {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        guard let postId = post.id else {return}
        let newData = ["body": body, "likes": 0, "userRef": userId, "timestamp": Timestamp(date: Date())] as [String : Any]
        
        let fetchedPost = try? await db.collection("posts").document(postId).getDocument(as: Post.self)
        
        guard let fetchedPost = fetchedPost else {return}
        
        do {
            try await self.db.collection("posts").document(postId).updateData(["comments": fetchedPost.comments + 1])
            let _ = try await self.db.collection("posts").document(postId).collection("comments").addDocument(data: newData)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

protocol CommentServiceProtocol {
    var isUpdated: Bool { get set }
    
    func fetchComments(post: Post) async -> [Comment]
    func checkIfCommentIsLiked(comment: Comment) async -> Bool
    func likeComment(post: Post, comment: Comment) async
    func unlikeComment(post: Post, comment: Comment) async
    func createComment(post: Post, body: String) async
}
