import Foundation
import FirebaseAuth

class SessionService: ObservableObject, SessionServiceProtocol {
    func getUserId() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    func login(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func isUserVerified() async -> Bool {
        return Auth.auth().currentUser?.isEmailVerified ?? false
    }
    
    func logout() throws {
        try Auth.auth().signOut()
    }
    
    func register(email: String, password: String) async throws {
       try await Auth.auth().createUser(withEmail: email, password: password)
    }
    
    func sendVerificationEmail() async throws {
        try await Auth.auth().currentUser?.sendEmailVerification()
    }
}

protocol SessionServiceProtocol {
    func getUserId() -> String?
    func login(email: String, password: String) async throws
    func isUserVerified() async -> Bool
    func logout() throws
    func register(email: String, password: String) async throws
    func sendVerificationEmail() async throws
}
