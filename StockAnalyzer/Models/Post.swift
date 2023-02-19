import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
import Firebase

struct Post: Identifiable, Codable {
    @DocumentID var id: String?
    let userRef: String
    let body: String
    let timestamp: Timestamp
    var likes: Int
    
    var user: User?
    var isLiked: Bool? = false
}
