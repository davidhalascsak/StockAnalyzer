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

extension View {
    func sync(_ published: Binding<Bool>, with binding: Binding<Bool>) -> some View {
        self
            .onChange(of: published.wrappedValue) { published in
                binding.wrappedValue = published
            }
            .onChange(of: binding.wrappedValue) { binding in
                published.wrappedValue = binding
            }
    }
}

