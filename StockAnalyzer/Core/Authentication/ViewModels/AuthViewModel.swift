import Foundation
import FirebaseCore
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var userData: AuthenticationUser = AuthenticationUser()
    @Published var isCorrect: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertText: String = ""
    @Published var alertTitle: String = ""
    @Published var isLogin: Bool = true
    
    var countries: [String] {
        let codes = NSLocale.isoCountryCodes
        let countries = codes.compactMap { code in
            locale.localizedString(forRegionCode: code)
        }
            
        return countries.sorted()
    }
    let locale = Locale(identifier: "en-US")
    let userService = UserService()
    
    public func checkLogin() {
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
        
        Auth.auth().signIn(withEmail: userData.email, password: userData.password) { authResult, error in
            if let error = error {
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
            
            guard let result = authResult else {return}
            
            if !result.user.isEmailVerified {
                do {
                    try Auth.auth().signOut()
                    
                    self.alertTitle = "Error"
                    self.alertText = "You must verify your account!"
                    self.showAlert.toggle()
                } catch let error {
                    print(error)
                }
                
                return
            }
            
            self.isCorrect.toggle()
            self.alertText = ""
            self.alertTitle = ""
            self.userData.email = ""
            self.userData.password = ""
        }
    }
    
    public func checkRegistration() {
        
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
        
        Auth.auth().createUser(withEmail: userData.email, password: userData.password) { authResult, error in
            var isInUse = false
            self.userService.fetchAllUser { users in
                users.forEach { user in
                    if user.username == self.userData.username {
                        isInUse = true
                    }
                }
                
                if isInUse {
                    self.alertTitle = "Error"
                    self.alertText = "The username is already in use!"
                    self.showAlert.toggle()
                    
                    return
                } else {
                    if error != nil {
                        self.alertTitle = "Error"
                        self.alertText = "The email is already in use!"
                        self.showAlert.toggle()
                        
                        return
                    } else {
                        guard let result = authResult else {return}
                        result.user.sendEmailVerification { error in
                            if error != nil {

                                return
                            }
                        }
                    }
                }
                let newUser = User(id: Auth.auth().currentUser?.uid ?? "", username: self.userData.username, email: self.userData.email, location: self.userData.location)
                
                self.userService.createUser(user: newUser) {
                    self.alertTitle = "Success"
                    self.alertText = "Please verify your account, before login!"
                    self.showAlert.toggle()
                    self.isCorrect.toggle()
                }
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func countryFlag(_ countryCode: String) -> String {
      String(String.UnicodeScalarView(countryCode.unicodeScalars.compactMap {
        UnicodeScalar(127397 + $0.value)
      }))
    }

}
