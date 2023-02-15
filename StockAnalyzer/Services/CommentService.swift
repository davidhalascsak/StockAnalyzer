import Foundation
import FirebaseFirestore

struct CommentService {
    var db = Firestore.firestore().collection("posts")
    
    
    func FetchComment(post: Post, completion: @escaping (([Comment]) -> Void)) {
        var comments = [Comment]()
        db.document(post.id ?? "").collection("comments").getDocuments { snapshot, error in
            guard let snapshot = snapshot else {return}
            
            comments = snapshot.documents.compactMap({try? $0.data(as: Comment.self)})
            
            completion(comments)
        }
    }
}
