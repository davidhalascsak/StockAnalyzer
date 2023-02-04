import SwiftUI


struct SignupView: View {
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
                SecureField("confirm password", text: $vm.userData.passwordAgain)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)

                Button {
                    vm.checkRegistration()
                } label: {
                    Text("Sign in")
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .padding()
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(15)
                }
                
                Divider()
                    .padding(.vertical)
                
                HStack {
                    Text("Have an account?")
                    Button {
                        withAnimation(.easeIn(duration: 0.2)) {
                            vm.isLogin.toggle()
                        }
                    } label: {
                        Text("Sign in")
                            .foregroundColor(Color.green)
                    }
                }
                
                Spacer()
            }
            .padding()
            .alert(vm.alertTitle, isPresented: $vm.showAlert, actions: {
                    Button("Ok", role: .cancel, action: {
                        if vm.isCorrect {
                            vm.isCorrect.toggle()
                            vm.showAlert.toggle()
                            vm.alertTitle = ""
                            vm.alertText = ""
                            vm.userData.email = ""
                            vm.userData.password = ""
                            vm.userData.passwordAgain = ""
                            
                            
                            vm.isLogin.toggle()
                        }
                    })
            }, message: {
                Text(vm.alertText)
            })
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView(vm: AuthViewModel())
    }
}
