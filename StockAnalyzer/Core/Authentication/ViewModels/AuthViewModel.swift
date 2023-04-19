import Foundation
import UIKit
import FirebaseCore
import FirebaseAuth

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userData: AuthenticationUser = AuthenticationUser()
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
                _ = self.sessionService.logout()
                
                self.alertTitle = "Error"
                self.alertText = "You must verify your account!"
                self.showAlert.toggle()
                
                return
            }
        } catch let error {
            if error.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                self.alertTitle = "Error"
                self.alertText = "The user is not found!"
                self.showAlert.toggle()
            } else {
                self.alertTitle = "Error"
                self.alertText = "The password is not correct!"
                self.showAlert.toggle()
            }
            
            return
        }
            
        self.isCorrect.toggle()
        self.alertText = ""
        self.alertTitle = ""
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
            self.alertTitle = "Error"
            self.alertText = "The username is already in use!"
            self.showAlert.toggle()
            
            return
        }
        
        let image = UIImage(named: "default_avatar")
        
        if let image = image {
            let imageUrl = await self.imageService.uploadImage(image: image)
            
            
            if let imageUrl = imageUrl {
                do {
                    try await sessionService.register(email: userData.email, password: userData.password)
                    
                    let newUser = User(id: self.sessionService.getUserId() ?? "", username: self.userData.username, email: self.userData.email, location: self.userData.location, imageUrl: imageUrl)
                    
                    do {
                        try await self.sessionService.sendVerificationEmail()
                    } catch {
                        self.alertTitle = "Error"
                        self.alertText = "Error while sending verification email!"
                        self.showAlert.toggle()
                        
                        return
                    }
                    _ = self.sessionService.logout()
                    try await self.userService.createUser(user: newUser)
                    
                } catch let error {
                    print(error)
                    self.alertTitle = "Error"
                    self.alertText = "Error while creating the user!"
                    self.showAlert.toggle()
                    self.isCorrect.toggle()
                }
                
                self.alertTitle = "Success"
                self.alertText = "Please verify your account, before login!"
                self.showAlert.toggle()
                self.isCorrect.toggle()
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
