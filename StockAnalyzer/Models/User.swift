import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var username: String
    var email: String
    var location: String
    // var portfolio: [Stock]
    // var image: UIImage
}
