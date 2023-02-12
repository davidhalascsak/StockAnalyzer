import Foundation
import FirebaseFirestore
import SwiftUI

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
}
