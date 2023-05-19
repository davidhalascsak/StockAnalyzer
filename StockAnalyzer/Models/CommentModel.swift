import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Comment: Identifiable, Codable {
    @DocumentID var id: String?
    let userRef: String
    let body: String
    let timestamp: Timestamp
    var likeCount: Int
    
    var user: CurrentUser?
    var isLiked: Bool? = false
}
