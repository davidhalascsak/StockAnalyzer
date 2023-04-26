import Foundation
import UIKit
import FirebaseCore
import FirebaseAuth

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userData: AuthenticationUser
    @Published var isCorrect: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertText: String = ""
    @Published var alertTitle: String = ""
    @Published var isLogin: Bool
    
    let userService: UserServiceProtocol
    let sessionService: SessionServiceProtocol
    let imageService: ImageServiceProtocol
    
    let locale = Locale(identifier: "en-US")
    
    var countries: [String] {
        let codes = NSLocale.isoCountryCodes
        let countries = codes.compactMap { code in
            locale.localizedString(forRegionCode: code)
        }
            
        return countries.sorted()
    }
    
    init(isLogin: Bool, userService: UserServiceProtocol, sessionService: SessionServiceProtocol, imageService: ImageServiceProtocol) {
        self.isLogin = isLogin
        self.userService = userService
        self.sessionService = sessionService
        self.imageService = imageService
        self.userData = AuthenticationUser()
    }
    
    public func checkLogin() async {
        if userData.email.count < 5 {
            alertTitle = "Error"
            alertText = "The email must be at least 5 characters long!"
            showAlert.toggle()
            
            return
        } else {
            if !isValidEmail(userData.email) {
                alertTitle = "Error"
                alertText = "The email format is not valid!"
                showAlert.toggle()
                
                return
            }
        }
        
        if userData.password.count < 6 {
            alertTitle = "Error"
            alertText = "The password must be at least 6 characters long!"
            showAlert.toggle()
            
            return
        }
        
        do {
            try await sessionService.login(email: userData.email, password: userData.password)
            
            let isVerified = await sessionService.isUserVerified()
            
            if !isVerified {
                alertTitle = "Verification Error"
                alertText = "You must verify your account!"
                showAlert.toggle()
                
                return
            }
            
        } catch let error {
            if error.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                self.alertTitle = "Login Error"
                self.alertText = "The user is not found!"
                self.showAlert.toggle()
            } else {
                alertTitle = "Login Error"
                alertText = "The password is not correct!"
                showAlert.toggle()
            }
            
            return
        }

        userData.email = ""
        userData.password = ""
    }
    
    public func checkRegistration() async {
        
        if userData.username.count < 5 {
            alertTitle = "Error"
            alertText = "The username must be at least 5 characters long!"
            showAlert.toggle()
            
            return
        }
        
        if userData.email.count < 5 {
            alertTitle = "Error"
            alertText = "The email must be at least 5 characters long!"
            showAlert.toggle()
            
            return
        } else {
            if !isValidEmail(userData.email) {
                alertTitle = "Error"
                alertText = "The email format is not valid!"
                showAlert.toggle()
                
                return
            }
        }
        
        if userData.password.count < 6 {
            alertTitle = "Error"
            alertText = "The password must be at least 6 characters long!"
            showAlert.toggle()
            
            return
        } else {
            if userData.password != userData.passwordAgain {
                alertTitle = "Error"
                alertText = "The two passwords does not match!"
                showAlert.toggle()
                
                return
            }
        }
        var isUsernameInUse: Bool = false
        
        let users = await userService.fetchAllUser()
        users.forEach { user in
            if user.username == userData.username {
                isUsernameInUse = true
            }
        }
        
        if isUsernameInUse {
            alertTitle = "Registration Error"
            alertText = "The username is already in use!"
            showAlert.toggle()
            
            return
        }
        
        guard let image = UIImage(named: "default_avatar") else {
            alertTitle = "Registration Error"
            alertText = "Error while creating the user!0"
            showAlert.toggle()
            isCorrect.toggle()
            
            return
        }
        
        guard let imageUrl = await imageService.uploadImage(image: image) else {
            alertTitle = "Registration Error"
            alertText = "Error while creating the user!1"
            showAlert.toggle()
            isCorrect.toggle()
            
            return
        }
        
        do {
            try await sessionService.register(email: userData.email, password: userData.password)
        } catch {
            alertTitle = "Registration Error"
            alertText = "The email is already in use!"
            showAlert.toggle()
            _ = logout()
            
            return
        }
        
        if let userId = self.sessionService.getUserId() {
            
            let newUser = User(id: userId, username: userData.username, email: userData.email, location: userData.location, imageUrl: imageUrl)
            
            do {
                try await userService.createUser(user: newUser)
            } catch {
                alertTitle = "Registration Error"
                alertText = "Error while saving the user!"
                showAlert.toggle()
                _ = logout()
                
                return
            }
            
            try? await sessionService.sendVerificationEmail()
            _ = logout()
        } else {
            alertTitle = "Registration Error"
            alertText = "Error while creating the user object!2"
            showAlert.toggle()
            
            return
        }
        alertTitle = "Success"
        alertText = "Please verify your account, before login!"
        showAlert.toggle()
    }
    
    func sendVerificationEmail() async {
        try? await sessionService.sendVerificationEmail()
    }
    
    func logout() {
        _ = sessionService.logout()
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
