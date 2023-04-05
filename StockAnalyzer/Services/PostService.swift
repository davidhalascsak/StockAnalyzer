import Foundation
import FirebaseFirestore
import FirebaseAuth
import Firebase

class PostService: PostServiceProtocol {
    @Published var isUpdated: Bool = true
    
    private var db = Firestore.firestore()
    
    func fetchPosts(symbol: String?) async -> [Post] {
        var posts = [Post]()
        
        if let symbol = symbol {
            let snapshot = try? await db.collection("posts").whereField("symbol", isEqualTo: symbol).order(by: "timestamp", descending: true).getDocuments()
            guard let snapshot = snapshot else {return []}
            
            posts = snapshot.documents.compactMap({try? $0.data(as: Post.self)})
            return posts
        } else {
            let snapshot = try? await db.collection("posts").order(by: "timestamp", descending: true).getDocuments()
            guard let snapshot = snapshot else {return []}
                    
            posts = snapshot.documents.compactMap({try? $0.data(as: Post.self)})
            return posts
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
    
    func likePost(post: Post) async {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        guard let postId = post.id else {return}
        
        let likedPosts = db.collection("users").document(userId).collection("likedPosts")
        let fetchedPost = try? await db.collection("posts").document(postId).getDocument(as: Post.self)
        
        guard let fetchedPost = fetchedPost else {return}
        
        do {
            try await self.db.collection("posts").document(postId).updateData(["likes": fetchedPost.likes + 1])
            try await likedPosts.document(postId).setData([:])
        } catch let error {
            print(error.localizedDescription)
        }
        self.isUpdated = true
    }
    
    func unlikePost(post: Post) async {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        guard let postId = post.id else {return}
        
        let likedPosts = db.collection("users").document(userId).collection("likedPosts")
        let fetchedPost = try? await db.collection("posts").document(postId).getDocument(as: Post.self)
        
        guard let fetchedPost = fetchedPost else {return}
        
        do {
            try await self.db.collection("posts").document(postId).updateData(["likes": fetchedPost.likes - 1])
            try await likedPosts.document(postId).delete()
        } catch let error {
            print(error.localizedDescription)
        }
        self.isUpdated = true
    }
    
    func createPost(body: String, symbol: String?) async {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        
        var data: [String : Any]
        
        if let symbol = symbol {
            data = ["body": body, "likes": 0, "comments": 0, "userRef": userId, "timestamp": Timestamp(date: Date()), "symbol": symbol]
        } else {
            data = ["body": body, "likes": 0, "comments": 0, "userRef": userId, "timestamp": Timestamp(date: Date()), "symbol": ""]
        }
        _ = try? await db.collection("posts").addDocument(data: data)
    }
}

protocol PostServiceProtocol {
    var isUpdated: Bool { get set }
    
    func fetchPosts(symbol: String?) async -> [Post]
    func checkIfPostIsLiked(post: Post) async -> Bool
    func likePost(post: Post) async
    func unlikePost(post: Post) async
    func createPost(body: String, symbol: String?) async
}
