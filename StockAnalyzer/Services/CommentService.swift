import Foundation
import FirebaseFirestore
import FirebaseAuth

class CommentService: CommentServiceProtocol {
    private var db = Firestore.firestore()
    
    func fetchComments(post: Post) async -> [Comment] {
        guard let postId = post.id else {return []}
        
        let snapshot = try? await db.collection("posts").document(postId).collection("comments").order(by: "timestamp", descending: true).getDocuments()
        guard let snapshot = snapshot else {return []}
        
        return snapshot.documents.compactMap({try? $0.data(as: Comment.self)})
    }
    
    func checkIfCommentIsLiked(comment: Comment) async -> Bool {
        guard let userId = Auth.auth().currentUser?.uid else {return false}
        guard let commentId = comment.id else {return false}
        
        let snapshot = try? await db.collection("users").document(userId).collection("likedComments").document(commentId).getDocument()
        guard let snapshot = snapshot else {return false}
        
        return snapshot.exists
    }
    
    func likeComment(post: Post, comment: Comment) async -> Bool {
        guard let userId = Auth.auth().currentUser?.uid else {return false}
        guard let postId = post.id else {return false}
        guard let commentId = comment.id else {return false}
        
        let likedComments = db.collection("users").document(userId).collection("likedComments")
        let fetchedComment = try? await db.collection("posts").document(postId).collection("comments").document(commentId).getDocument(as: Comment.self)
        
        guard let fetchedComment = fetchedComment else {return false}
        
        do {
            try await db.collection("posts").document(postId).collection("comments").document(commentId).updateData(["likeCount": fetchedComment.likeCount + 1])
            try await likedComments.document(commentId).setData([:])
            
            return true
        } catch {
            return false
        }
    }
    
    func unlikeComment(post: Post, comment: Comment) async -> Bool {
        guard let userId = Auth.auth().currentUser?.uid else {return false}
        guard let postId = post.id else {return false}
        guard let commentId = comment.id else {return false}
        
        let likedComments = db.collection("users").document(userId).collection("likedComments")
        let fetchedComment = try? await db.collection("posts").document(postId).collection("comments").document(commentId).getDocument(as: Comment.self)
        
        guard let fetchedComment = fetchedComment else {return false}
        
        do {
            try await self.db.collection("posts").document(postId).collection("comments").document(commentId).updateData(["likeCount": fetchedComment.likeCount - 1])
            try await likedComments.document(commentId).delete()
            
            return true
        } catch {
            return false
        }
    }
    
    func createComment(post: Post, body: String) async -> Bool {
        guard let userId = Auth.auth().currentUser?.uid else {return false}
        guard let postId = post.id else {return false}
        let newData = ["body": body, "likeCount": 0, "userRef": userId, "timestamp": Timestamp(date: Date())] as [String : Any]
        
        let fetchedPost = try? await db.collection("posts").document(postId).getDocument(as: Post.self)
        
        guard let fetchedPost = fetchedPost else {return false}
        
        do {
            try await self.db.collection("posts").document(postId).updateData(["comments": fetchedPost.commentCount + 1])
            let _ = try await self.db.collection("posts").document(postId).collection("comments").addDocument(data: newData)
            
            return true
        } catch {
            return false
        }
    }
}

class MockCommentService: CommentServiceProtocol {
    var db: MockDatabase = MockDatabase()
    var currentUser: TestAuthenticationUser?
    
    init(currentUser: TestAuthenticationUser?) {
        self.currentUser = currentUser
    }
    
    func fetchComments(post: Post) async -> [Comment] {
        return db.comments[post.id ?? ""] ?? []
    }
    
    func checkIfCommentIsLiked(comment: Comment) async -> Bool {
        guard let userId = currentUser?.id else {return false}
        
        return db.likedComments[userId]?.contains(where: {$0 == comment.id}) ?? false
    }
    
    func likeComment(post: Post, comment: Comment) async -> Bool {
        guard let userId = currentUser?.id else {return false}
        
        guard let postIndex = db.posts.firstIndex(where: {$0.id == post.id}) else { return false}
        guard let commentIndex = db.comments[db.posts[postIndex].id ?? ""]?.firstIndex(where: {$0.id == comment.id})
            else {return false}
        
        let result = db.likedComments[userId]?.contains(where: {$0 == comment.id})
        if result == false {
            db.comments[post.id ?? ""]?[commentIndex].likeCount += 1
            db.likedComments[userId]?.append(comment.id ?? "")
            
            return true
        }
        
        return false
    }
    
    func unlikeComment(post: Post, comment: Comment) async -> Bool {
        guard let userId = currentUser?.id else {return false}
        
        guard let postIndex = db.posts.firstIndex(where: {$0.id == post.id}) else { return false}
        guard let commentIndex = db.comments[db.posts[postIndex].id ?? ""]?.firstIndex(where: {$0.id == comment.id})
            else {return false}
        
        let result = db.likedComments[userId]?.contains(where: {$0 == comment.id})
        if result == true {
            db.comments[post.id ?? ""]?[commentIndex].likeCount -= 1
            db.likedComments[userId]?.removeAll(where: {$0 == comment.id})
            
            return true
        }
        
        return false
    }
    
    func createComment(post: Post, body: String) async -> Bool {
        guard let userId = currentUser?.id else {return false}
        guard let index = db.posts.firstIndex(where: {$0.id == post.id}) else {return false}
        
        let newComment = Comment(id: UUID().uuidString, userRef: userId, body: body, timestamp: Timestamp(), likeCount: 0)
        db.comments[post.id ?? ""]?.append(newComment)
        db.posts[index].likeCount += 1
        
        return true
    }
}

protocol CommentServiceProtocol {
    func fetchComments(post: Post) async -> [Comment]
    func checkIfCommentIsLiked(comment: Comment) async -> Bool
    func likeComment(post: Post, comment: Comment) async -> Bool
    func unlikeComment(post: Post, comment: Comment) async -> Bool
    func createComment(post: Post, body: String) async -> Bool
}
