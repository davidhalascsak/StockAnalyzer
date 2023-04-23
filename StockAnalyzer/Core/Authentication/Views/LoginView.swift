import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: AuthViewModel
    @State var isCorrect: Bool = false
    @State var showAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                TextField("email", text: $vm.userData.email)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)
                SecureField("password", text: $vm.userData.password)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)
                
                
                Button {
                    Task {
                        await vm.checkLogin()
                    }
                } label: {
                    Text("Sign in")
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .padding()
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(15)
                }
                
                Divider()
                    .padding(.vertical)
                
                HStack {
                    Text("Don't have an account?")
                    Button {
                        withAnimation(.easeIn(duration: 0.2)) {
                            vm.isLogin.toggle()
                            vm.alertText = ""
                            vm.alertTitle = ""
                            vm.userData.email = ""
                            vm.userData.password = ""
                        }
                    } label: {
                        Text("Sign up")
                            .foregroundColor(Color.blue)
                    }
                }
                
                Spacer()
            }
            .padding()
            .onChange(of: vm.isCorrect, perform: { newValue in
                dismiss()
            })
            .alert(vm.alertTitle, isPresented: $showAlert, actions: {
                if(vm.alertTitle == "Verification Error") {
                    Button("Send again", role: .none) {
                        Task {
                            await vm.sendVerificationEmail()
                        }
                    }
                }
                Button("Ok", role: .cancel, action: { vm.logout() })
            }, message: {
                Text(vm.alertText)
            })
            .sync($vm.isCorrect, with: $isCorrect)
            .sync($vm.showAlert, with: $showAlert)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "arrowshape.backward")
                        .onTapGesture {
                            dismiss()
                        }
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(vm: AuthViewModel(isLogin: true, userService: UserService(), sessionService: SessionService(), imageService: ImageService()))
    }
}
