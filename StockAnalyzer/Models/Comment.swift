import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct Comment: Identifiable, Codable {
    @DocumentID var id: String?
    let userRef: DocumentReference?
    let body: String
    var likes: Int
    
    var user: User?
}
