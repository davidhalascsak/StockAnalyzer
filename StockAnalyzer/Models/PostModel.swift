import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct Post: Identifiable, Codable {
    @DocumentID var id: String?
    let userRef: String
    let body: String
    var likeCount: Int
    var commentCount: Int
    var stockSymbol: String?
    let timestamp: Timestamp
    
    var user: User?
    var isLiked: Bool? = false
}
