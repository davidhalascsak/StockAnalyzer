import Foundation
import UIKit
import Firebase
import FirebaseStorage

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
    
    func logout() -> Bool {
        do {
            try Auth.auth().signOut()
            
            return true
        } catch let error {
            print(error.localizedDescription)
        }
        return false
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
    func logout() -> Bool
    func register(email: String, password: String) async throws
    func sendVerificationEmail() async throws
}
