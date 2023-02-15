import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct Post: Identifiable, Codable {
    @DocumentID var id: String?
    let userRef: String
    let body: String
    var likes: Int
    
    var user: User?
}
