import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                if Auth.auth().currentUser != nil {
                    LogOut()
                } else {
                    NavigationLink {
                        LoginView(vm: AuthViewModel())
                    } label: {
                        Text("Sign in")
                    }

                }
            }
            .navigationBarBackButtonHidden()
            .navigationTitle("User")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Image(systemName: "xmark")
                        .onTapGesture {
                            dismiss()
                        }
                }
            }
        }
    }
}

struct LogOut: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Button {
            do {
                try Auth.auth().signOut()
                Auth.auth().currentUser?.reload()
                dismiss()
            } catch {
                print("error while signing out")
            }
        } label: {
            Text("sign out")
        }

    }
}

struct SettingsView_Previews: PreviewProvider {
    
    static var previews: some View {
        SettingsView()
    }
}
