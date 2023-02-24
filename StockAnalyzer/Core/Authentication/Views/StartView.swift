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

struct ContentView_Previews: PreviewProvider {
    @State static var isPresented: Bool = true
    
    static var previews: some View {
        StartView(isLogin: true)
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
    
    func toDate(stamp: Timestamp) -> String {
        let difference = Date().timeIntervalSince(stamp.dateValue())
        let diffInMinutes = difference / 60
        
        if diffInMinutes < 60 {
            return "\(String(format: "%.0f", diffInMinutes))m"
        } else if diffInMinutes >= 60 && diffInMinutes < 24 * 60 {
            return "\(String(format: "%.0f", diffInMinutes / 60))h"
        } else if diffInMinutes >= 24 * 60 && diffInMinutes < 7 * 24 * 60 {
            return "\(String(format: "%.0f", diffInMinutes / (60 * 24)))d"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            
            return formatter.string(from: stamp.dateValue())
        }
    }
}

