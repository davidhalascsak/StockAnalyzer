import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Comment: Identifiable, Codable {
    @DocumentID var id: String?
    let userRef: String
    let body: String
    let timestamp: Timestamp
    var likes: Int
    
    var user: User?
    var isLiked: Bool? = false
}
