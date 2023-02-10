import SwiftUI
import FirebaseCore
import FirebaseAuth


struct StartView: View {
    @StateObject private var vm = AuthViewModel()
    
    var body: some View {     
        if vm.isLogin {
            LoginView(vm: vm)
        } else {
            SignupView(vm: vm)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
