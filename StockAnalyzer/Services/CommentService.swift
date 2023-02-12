import Foundation
import FirebaseFirestore

struct CommentService {
    
    func FetchComments(ref: DocumentReference?, completion: @escaping ((Comment) -> Void)) {
        ref?.getDocument { snapshot, error in
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
