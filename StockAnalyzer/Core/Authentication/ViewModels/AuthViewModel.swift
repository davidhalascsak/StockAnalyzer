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
            try await self.sessionService.login(email: userData.email, password: userData.password)
            
            let isVerified = await sessionService.isUserVerified()
            
            if !isVerified {
                self.alertTitle = "Verification Error"
                self.alertText = "You must verify your account!"
                self.showAlert.toggle()
                
                return
            }
            
        } catch let error {
            if error.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                self.alertTitle = "Login Error"
                self.alertText = "The user is not found!"
                self.showAlert.toggle()
            } else {
                self.alertTitle = "Login Error"
                self.alertText = "The password is not correct!"
                self.showAlert.toggle()
            }
            
            return
        }

        self.userData.email = ""
        self.userData.password = ""
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
        
        let users = await self.userService.fetchAllUser()
        users.forEach { user in
            if user.username == self.userData.username {
                isUsernameInUse = true
            }
        }
        
        if isUsernameInUse {
            self.alertTitle = "Registration Error"
            self.alertText = "The username is already in use!"
            self.showAlert.toggle()
            
            return
        }
        
        guard let image = UIImage(named: "default_avatar") else {
            self.alertTitle = "Registration Error"
            self.alertText = "Error while creating the user!0"
            self.showAlert.toggle()
            self.isCorrect.toggle()
            
            return
        }
        
        guard let imageUrl = await self.imageService.uploadImage(image: image) else {
            self.alertTitle = "Registration Error"
            self.alertText = "Error while creating the user!1"
            self.showAlert.toggle()
            self.isCorrect.toggle()
            
            return
        }
        
        do {
            try await self.sessionService.register(email: self.userData.email, password: self.userData.password)
        } catch {
            self.alertTitle = "Registration Error"
            self.alertText = "The email is already in use!"
            self.showAlert.toggle()
            _ = self.logout()
            
            return
        }
        
        if let userId = self.sessionService.getUserId() {
            
            let newUser = User(id: userId, username: self.userData.username, email: self.userData.email, location: self.userData.location, imageUrl: imageUrl)
            
            do {
                try await self.userService.createUser(user: newUser)
            } catch {
                self.alertTitle = "Registration Error"
                self.alertText = "Error while saving the user!"
                self.showAlert.toggle()
                _ = self.logout()
                
                return
            }
            
            try? await self.sessionService.sendVerificationEmail()
            _ = self.logout()
        } else {
            self.alertTitle = "Registration Error"
            self.alertText = "Error while creating the user object!2"
            self.showAlert.toggle()
            
            return
        }
        self.alertTitle = "Success"
        self.alertText = "Please verify your account, before login!"
        self.showAlert.toggle()
    }
    
    func sendVerificationEmail() async {
        try? await self.sessionService.sendVerificationEmail()
    }
    
    func logout() {
        _ = self.sessionService.logout()
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
