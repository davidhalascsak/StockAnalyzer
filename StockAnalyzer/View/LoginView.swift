import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


struct LoginView: View {
    @ObservedObject var vm: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                TextField("email", text: $vm.userData.email)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)
                SecureField("password", text: $vm.userData.password)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)
                
                Button {
                    vm.checkLogin()
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
            .navigationDestination(isPresented: $vm.isCorrect) {
                MainView()
            }
            .alert(vm.alertTitle, isPresented: $vm.showAlert, actions: {
                Button("Ok", role: .cancel, action: {})
            }, message: {
                Text(vm.alertText)
            })
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(vm: AuthViewModel())
    }
}
