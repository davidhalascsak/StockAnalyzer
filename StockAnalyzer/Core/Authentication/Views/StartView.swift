import SwiftUI
import FirebaseCore
import FirebaseAuth
import Firebase


struct StartView: View {
    @StateObject private var vm: AuthViewModel
    
    init(isLogin: Bool) {
        _vm = StateObject(wrappedValue: AuthViewModel(isLogin: isLogin))
    }
    
    var body: some View {
        if vm.isLogin {
            LoginView(vm: vm)
        } else {
            SignupView(vm: vm)
        }
    }
}

struct StartView_Previews: PreviewProvider {
    @State static var isPresented: Bool = true
    
    static var previews: some View {
        StartView(isLogin: true)
    }
}


