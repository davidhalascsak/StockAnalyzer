import Foundation
import FirebaseFirestore
import FirebaseAuth
import Firebase

class PostService: PostServiceProtocol {
    private var db = Firestore.firestore()
    
    func fetchPosts(stockSymbol: String?) async -> [Post] {       
        if let stockSymbol = stockSymbol {
            let snapshot = try? await db.collection("posts").whereField("symbol", isEqualTo: stockSymbol).order(by: "timestamp", descending: true).getDocuments()
            guard let snapshot = snapshot else {return []}
            
            return snapshot.documents.compactMap({try? $0.data(as: Post.self)})
        } else {
            let snapshot = try? await db.collection("posts").order(by: "timestamp", descending: true).getDocuments()
            guard let snapshot = snapshot else {return []}
                    
            return snapshot.documents.compactMap({try? $0.data(as: Post.self)})
        }
    }
    
    func checkIfPostIsLiked(post: Post) async -> Bool {
        if let userId = Auth.auth().currentUser?.uid {
            guard let postId = post.id else {return false}
            
            let snapshot = try? await db.collection("users").document(userId).collection("likedPosts").document(postId).getDocument()
            guard let snapshot = snapshot else {return false}
            
            return snapshot.exists
        }
        return false
    }
    
    func likePost(post: Post) async -> Bool {
        guard let userId = Auth.auth().currentUser?.uid else {return false}
        guard let postId = post.id else {return false}
        
        let likedPosts = db.collection("users").document(userId).collection("likedPosts")
        let fetchedPost = try? await db.collection("posts").document(postId).getDocument(as: Post.self)
        
        guard let fetchedPost = fetchedPost else {return false}
        
        do {
            try await self.db.collection("posts").document(postId).updateData(["likeCount": fetchedPost.likeCount + 1])
            try await likedPosts.document(postId).setData([:])
            
            return true
        } catch {
            return false
        }
    }
    
    func unlikePost(post: Post) async -> Bool {
        guard let userId = Auth.auth().currentUser?.uid else {return false}
        guard let postId = post.id else {return false}
        
        let likedPosts = db.collection("users").document(userId).collection("likedPosts")
        let fetchedPost = try? await db.collection("posts").document(postId).getDocument(as: Post.self)
        
        guard let fetchedPost = fetchedPost else {return false}
        
        do {
            try await self.db.collection("posts").document(postId).updateData(["likeCount": fetchedPost.likeCount - 1])
            try await likedPosts.document(postId).delete()
            
            return true
        } catch {
            return false
        }
    }
    
    func createPost(body: String, stockSymbol: String?) async -> Bool {
        guard let userId = Auth.auth().currentUser?.uid else {return false}
        
        var data: [String : Any]
        
        if let stockSymbol = stockSymbol {
            data = ["body": body, "likeCount": 0, "commentCount": 0, "userRef": userId, "symbol": stockSymbol, "timestamp": Timestamp(date: Date())]
        } else {
            data = ["body": body, "likeCount": 0, "commentCount": 0, "userRef": userId, "timestamp": Timestamp(date: Date())]
        }
        
        do {
            _ = try await db.collection("posts").addDocument(data: data)
            return true
        } catch {
            return false
        }
        
    }
}

class MockPostService: PostServiceProtocol {
    var db: MockDatabase = MockDatabase()
    var currentUser: TestAuthenticationUser?
    
    init(currentUser: TestAuthenticationUser?) {
        self.currentUser = currentUser
    }
    
    func fetchPosts(stockSymbol: String?) async -> [Post] {
        if let symbol = stockSymbol {
            return db.posts.filter({$0.stockSymbol == symbol})
        } else {
            return db.posts
        }
    }
    
    func checkIfPostIsLiked(post: Post) async -> Bool {
        guard let userId = currentUser?.id else {return false}
        return db.likedPosts[userId]?.contains(where: {$0 == post.id}) ?? false
    }
    
    func likePost(post: Post) async -> Bool {
        guard let userId = currentUser?.id else {return false}
        guard let index = db.posts.firstIndex(where: {$0.id == post.id}) else { return false}
        
        let result = db.likedPosts[userId]?.contains(where: {$0 == post.id})
        if result == false {
            db.likedPosts[userId]?.append(post.id ?? "")
            db.posts[index].likeCount += 1
            
            return true
        }
        return false
    }
    
    func unlikePost(post: Post) async -> Bool {
        guard let userId = currentUser?.id else {return false}
        guard let index = db.posts.firstIndex(where: {$0.id == post.id}) else { return false}
        
        let result = db.likedPosts[userId]?.contains(where: {$0 == post.id})
        if result == true {
            db.likedPosts[userId]?.removeAll(where: {$0 == post.id})
            db.posts[index].likeCount -= 1
            
            return true
        }
        return false
    }
    
    func createPost(body: String, stockSymbol: String?) async -> Bool{
        guard let userId = currentUser?.id else {return false}
        if let symbol = stockSymbol {
            let newPost = Post(userRef: userId, body: body, likeCount: 0, commentCount: 0, stockSymbol: symbol, timestamp: Timestamp())
            db.posts.append(newPost)
            
        } else {
            let newPost = Post(userRef: userId, body: body, likeCount: 0, commentCount: 0, stockSymbol: nil,timestamp: Timestamp())
            db.posts.append(newPost)
        }
        
        return true
    }
}

protocol PostServiceProtocol {
    func fetchPosts(stockSymbol: String?) async -> [Post]
    func checkIfPostIsLiked(post: Post) async -> Bool
    func likePost(post: Post) async -> Bool
    func unlikePost(post: Post) async -> Bool
    func createPost(body: String, stockSymbol: String?) async -> Bool
}
