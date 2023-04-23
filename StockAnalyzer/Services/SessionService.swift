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
    
    func sendVerificationEmail() async throws {
        try await Auth.auth().currentUser?.sendEmailVerification()
    }
}

class MockSessionService: ObservableObject, SessionServiceProtocol {
    var users: [User] = []
    var authUsers: [AuthUser] = []
    var currentUser: AuthUser?

    init() {
        let uid1 = UUID().uuidString
        let user1 = User(id: uid1, username: "david", email: "david@domain.com", location: "Hungary", imageUrl: "")
        let authUser1 = AuthUser(id: uid1, email: "david@domain.com", password: "asd123", isVerified: true)
        
        let uid2 = UUID().uuidString
        let user2 = User(id: uid2, username: "bob", email: "bob@domain.com", location: "Hungary", imageUrl: "")
        let authUser2 = AuthUser(id: uid2, email: "bob@domain.com", password: "asd123", isVerified: false)
        
        users.append(user1)
        users.append(user2)
        
        authUsers.append(authUser1)
        authUsers.append(authUser2)
    }
    
    
    func getUserId() -> String? {
        return self.currentUser?.id ?? nil
    }
    
    func login(email: String, password: String) async throws {
        let user: AuthUser?
        user = authUsers.first(where: {$0.email == email}) ?? nil
        if user == nil {
            throw SessionError.loginError(message: "There is no user record corresponding to this identifier. The user may have been deleted.")
        } else if user != nil && user?.password != password {
            
            throw SessionError.loginError(message: "The password does not match")
        }
        
        self.currentUser = user
    }
    
    func isUserVerified() async -> Bool {
        let user = self.authUsers.first(where: {$0.email == self.currentUser?.email})
        return user?.isVerified ?? false
    }
    
    func logout() -> Bool {
        if self.currentUser != nil {
            return true
        } else {
            return false
        }
    }
    
    func register(email: String, password: String) async throws {
        let data = authUsers.first(where: {$0.email == email})
        if data != nil {
            throw SessionError.registrationError(message: "The email is already in use!")
        }
        let newAuthUser = AuthUser(id: UUID().uuidString, email: email, password: password, isVerified: false)
        
        self.authUsers.append(newAuthUser)
        self.currentUser = newAuthUser
    }
    
    func sendVerificationEmail() async throws {}
}

protocol SessionServiceProtocol {
    func getUserId() -> String?
    func login(email: String, password: String) async throws
    func isUserVerified() async -> Bool
    func logout() -> Bool
    func register(email: String, password: String) async throws
    func sendVerificationEmail() async throws
}
