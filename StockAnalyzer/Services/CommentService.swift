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
            try await db.collection("posts").document(postId).collection("comments").document(commentId).updateData(["likes": fetchedComment.likes + 1])
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
            try await self.db.collection("posts").document(postId).collection("comments").document(commentId).updateData(["likes": fetchedComment.likes - 1])
            try await likedComments.document(commentId).delete()
            
            return true
        } catch {
            return false
        }
    }
    
    func createComment(post: Post, body: String) async -> Bool {
        guard let userId = Auth.auth().currentUser?.uid else {return false}
        guard let postId = post.id else {return false}
        let newData = ["body": body, "likes": 0, "userRef": userId, "timestamp": Timestamp(date: Date())] as [String : Any]
        
        let fetchedPost = try? await db.collection("posts").document(postId).getDocument(as: Post.self)
        
        guard let fetchedPost = fetchedPost else {return false}
        
        do {
            try await self.db.collection("posts").document(postId).updateData(["comments": fetchedPost.comments + 1])
            let _ = try await self.db.collection("posts").document(postId).collection("comments").addDocument(data: newData)
            
            return true
        } catch {
            return false
        }
    }
}

class MockCommentService: CommentServiceProtocol {
    var posts: [Post] = []
    var users: [User] = []
    var comments: [String: [Comment]] = [:]
    var likedComments: [String: [String]] = [:]
    
    init() {
        let post = Post(id: "19", userRef: "asd321", body: "Good Moring, Vietnam", timestamp: Timestamp(), likes: 2, comments: 2, symbol: "")
        posts.append(post)
        
        let user = User(id: "asd123", username: "david", email: "david@gmail.com", location: "Hungary", imageUrl: "https://test_image.com")
        users.append(user)
        
        let comment2 = Comment(id: "1", userRef: "asd123", body: "Guten Morgen", timestamp: Timestamp(), likes: 1)
        let comment1 = Comment(id: "2", userRef: "asd123", body: "Vietnaaam?", timestamp: Timestamp(), likes: 5)
        comments[post.id ?? ""] = [comment1, comment2]
        
        likedComments[user.id ?? ""] = ["2"]
    }
    
    func fetchComments(post: Post) async -> [Comment] {
        return comments[post.id ?? ""] ?? []
    }
    
    func checkIfCommentIsLiked(comment: Comment) async -> Bool {
        let userId = "asd123"
        return ((likedComments[userId]?.contains(where: {$0 == comment.id})) != nil)
    }
    
    func likeComment(post: Post, comment: Comment) async -> Bool {
        let userId = "asd123"
        guard let postIndex = posts.firstIndex(where: {$0.id == post.id}) else { return false}
        guard let commentIndex = comments[posts[postIndex].id ?? ""]?.firstIndex(where: {$0.id == comment.id})
            else {return false}
        
        let result = likedComments[userId]?.contains(where: {$0 == comment.id})
        if result == false {
            comments[post.id ?? ""]?[commentIndex].likes += 1
            likedComments[userId]?.append(comment.id ?? "")
            
            return true
        }
        
        return false
    }
    
    func unlikeComment(post: Post, comment: Comment) async -> Bool {
        let userId = "asd123"
        guard let postIndex = posts.firstIndex(where: {$0.id == post.id}) else { return false}
        guard let commentIndex = comments[posts[postIndex].id ?? ""]?.firstIndex(where: {$0.id == comment.id}) else {return false}
        
        let result = likedComments[userId]?.contains(where: {$0 == comment.id})
        if result == true {
            comments[post.id ?? ""]?[commentIndex].likes -= 1
            likedComments[userId]?.removeAll(where: {$0 == comment.id})
            
            return true
        }
        
        return false
    }
    
    func createComment(post: Post, body: String) async -> Bool {
        guard let index = posts.firstIndex(where: {$0.id == post.id}) else {return false}
        
        let newComment = Comment(id: UUID().uuidString, userRef: post.userRef, body: body, timestamp: Timestamp(), likes: 0)
        comments[post.id ?? ""]?.append(newComment)
        posts[index].likes += 1
        
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
