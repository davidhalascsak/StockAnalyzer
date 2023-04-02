import Foundation
import FirebaseAuth

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var user: User?
    
    let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    func fetchUser() async {
        self.user = nil
        guard let id = Auth.auth().currentUser?.uid else {return}
        
        self.user = await userService.fetchUser(id: id)
    }
}
