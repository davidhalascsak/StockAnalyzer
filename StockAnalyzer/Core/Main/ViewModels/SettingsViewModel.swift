import Foundation
import FirebaseAuth

class SettingsViewModel: ObservableObject {
    @Published var user: User?
    
    let userService = UserService()
    
    func fetchUser() {
        self.user = nil
        guard let id = Auth.auth().currentUser?.uid else {return}
        
        userService.fetchUser(id: id) { user in
            self.user = user
            
        }
    }
}
