import Foundation
import UIKit
import FirebaseFirestoreSwift
import FirebaseFirestore

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    let username: String
    let email: String
    let location: String
    var imageUrl: String
    
    var image: Data?
}

struct AuthUser {
    let id: String
    let email: String
    let password: String
    let isVerified: Bool
}
