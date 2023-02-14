import Foundation
import FirebaseFirestore

struct CommentService {
    
    func FetchComment(ref: DocumentReference?, completion: @escaping ((Comment) -> Void)) {
        if let ref = ref {
            ref.addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot else {return}
                
                do {
                    let comment = try snapshot.data(as: Comment.self)
                    completion(comment)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
