import Foundation
import UIKit
import FirebaseFirestoreSwift
import FirebaseFirestore

struct AuthenticationUser {
    var username: String = ""
    var email: String = ""
    var password: String = ""
    var passwordAgain: String = ""
    var country: String = "Hungary"
}

struct CurrentUser: Identifiable, Codable {
    @DocumentID var id: String?
    let username: String
    let email: String
    let country: String
    var imageUrl: String
    
    var image: Data?
}

struct TestAuthenticationUser {
    let id: String
    let email: String
    let password: String
    let isVerified: Bool
}
