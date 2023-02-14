import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct Comment: Identifiable, Codable {
    @DocumentID var id: String?
    let userRef: DocumentReference?
    let body: String
    var likesRef: [DocumentReference]
    
    var user: User?
}
