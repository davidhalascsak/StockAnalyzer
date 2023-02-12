import Foundation

class MainViewModel: ObservableObject {
    @Published var isSettingsPresented: Bool = false
    //@Published var user: User
    // news -> all/portfolio
    
    
    let userEmail: String
    
    init(email: String) {
        userEmail = email
    }
}
