import Foundation
import FirebaseAuth

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var user: User?
    
    let userService: UserServiceProtocol
    let sessionService: SessionServiceProtocol
    
    init(userService: UserServiceProtocol, sessionService: SessionServiceProtocol) {
        self.userService = userService
        self.sessionService = sessionService
    }
    
    func fetchUser() async {
        self.user = nil
        guard let id = Auth.auth().currentUser?.uid else {return}
        
        self.user = await userService.fetchUser(id: id)
    }
}
