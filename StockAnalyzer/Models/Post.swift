import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct Post: Identifiable, Codable {
    @DocumentID var id: String?
    let userRef: DocumentReference?
    let body: String
    var likes: Int
    var commentsRef: [DocumentReference]
    
    
    var comments: [Comment]?
    var user: User?
}
