import SwiftUI

struct SignupView: View {
    @ObservedObject var vm: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                TextField("username", text: $vm.userData.username)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)
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
                SecureField("confirm password", text: $vm.userData.passwordAgain)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)
                Picker("Country", selection: $vm.userData.location) {
                    ForEach(vm.countries, id: \.self) {
                        Text($0).tag($0)
                    }
                    .pickerStyle(.wheel)
                }
                .padding(2)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(15)
                Button {
                    Task {
                        await vm.checkRegistration()
                    }
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
                            vm.alertText = ""
                            vm.alertTitle = ""
                            vm.userData.username = ""
                            vm.userData.email = ""
                            vm.userData.password = ""
                            vm.userData.passwordAgain = ""
                            vm.userData.location = "Hungary"
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
                        dismiss()
                    }
                })
            }, message: {
                Text(vm.alertText)
            })
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

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView(vm: AuthViewModel(isLogin: false, userService: MockUserService(), sessionService: MockSessionService(currentUser: nil), imageService: MockImageService()))
    }
}
