import Foundation
import FirebaseFirestore

struct PostService {
    private var db = Firestore.firestore().collection("posts")
    
    func fetchPosts(completion: @escaping ([Post]) -> Void) {
        var posts = [Post]()
        
        db.addSnapshotListener({ snapshot, _ in
            guard let snapshot = snapshot else {return}
            
            posts = snapshot.documents.compactMap({try? $0.data(as: Post.self)})
            completion(posts)
        })
    }
    
    func updateLikes(post: Post, userId: DocumentReference, completion: @escaping (() -> Void)) {
        var isContains: Bool = false
        var index: Int = 0
        for i in 0..<post.likesRef.count {
            if post.likesRef[i].path == userId.path {
                index = i
                isContains = true
            }
        }
        var likes = post.likesRef
        if isContains {
            likes.remove(at: index)
        } else {
            likes.append(userId)
        }
        db.document(post.id ?? "").setData(["likesRef": likes], merge: true)
    }
}
