import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

enum SessionError: LocalizedError {
    case verificationError(message: String)
    case registrationError(message: String)
    case loginError(message: String)
}

extension SessionError {
    public var errorDescription: String? {
        switch self {
        case let .loginError(message):
            return message
        case let .registrationError(message):
            return message
        case let .verificationError(message):
            return message
        }
    }
}

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
        } catch {
            return false
        }
    }
    
    func register(email: String, password: String) async throws {
        try await Auth.auth().createUser(withEmail: email, password: password)
    }
    
    func deleteUser() async -> Bool {
        do {
            try await Auth.auth().currentUser?.delete()
            return true
        } catch {
            return false
        }
    }
    
    func sendVerificationEmail() async throws {
        try await Auth.auth().currentUser?.sendEmailVerification()
    }
}

class MockSessionService: ObservableObject, SessionServiceProtocol {
    var db: MockDatabase = MockDatabase()
    var currentUser: AuthUser?
    
    init(currentUser: AuthUser?) {
        self.currentUser = currentUser
    }
    
    func getUserId() -> String? {
        return self.currentUser?.id ?? nil
    }
    
    func login(email: String, password: String) async throws {
        let user: AuthUser?
        user = db.authUsers.first(where: {$0.email == email}) ?? nil
        
        if user == nil {
            throw SessionError.loginError(message: "There is no user record corresponding to this identifier. The user may have been deleted.")
        } else if user != nil && user?.password != password {
            throw SessionError.loginError(message: "The password does not match")
        }
        
        self.currentUser = user
    }
    
    func isUserVerified() async -> Bool {
        let user = db.authUsers.first(where: {$0.email == currentUser?.email})
        return user?.isVerified ?? false
    }
    
    func logout() -> Bool {
        if currentUser != nil {
            currentUser = nil
            return true
        } else {
            return false
        }
    }
    
    func register(email: String, password: String) async throws {
        let data = db.authUsers.first(where: {$0.email == email})
        if data != nil {
            throw SessionError.registrationError(message: "The email is already in use!")
        }
        let newAuthUser = AuthUser(id: UUID().uuidString, email: email, password: password, isVerified: false)
        
        db.authUsers.append(newAuthUser)
        currentUser = newAuthUser
    }
    
    func deleteUser() async -> Bool {
        db.authUsers.removeAll(where: {$0.id == currentUser?.id})
        
        return true
    }
    
    func sendVerificationEmail() async throws {}
}

protocol SessionServiceProtocol {
    func getUserId() -> String?
    func login(email: String, password: String) async throws
    func isUserVerified() async -> Bool
    func logout() -> Bool
    func register(email: String, password: String) async throws
    func deleteUser() async -> Bool
    func sendVerificationEmail() async throws
}
