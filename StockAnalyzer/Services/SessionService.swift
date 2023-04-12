import Foundation
import FirebaseAuth

class SessionService: ObservableObject, SessionServiceProtocol {
    func getUserId() -> String? {
        return Auth.auth().currentUser?.uid
    }
}

protocol SessionServiceProtocol {
    func getUserId() -> String?
}
