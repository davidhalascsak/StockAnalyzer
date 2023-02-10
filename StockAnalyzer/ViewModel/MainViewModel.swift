import Foundation

class MainViewModel: ObservableObject {
    @Published var isSettingsPresented: Bool = false
    
    let userEmail: String
    
    init(email: String){
        userEmail = email
    }
}
