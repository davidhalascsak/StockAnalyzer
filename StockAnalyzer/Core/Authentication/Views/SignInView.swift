import SwiftUI

struct SignInView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                TextField("email", text: $viewModel.userData.email)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)
                SecureField("password", text: $viewModel.userData.password)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)
                Button {
                    Task {
                        await viewModel.checkLogin()
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
                            viewModel.isLogin.toggle()
                            viewModel.alertText = ""
                            viewModel.alertTitle = ""
                            viewModel.userData.email = ""
                            viewModel.userData.password = ""
                        }
                    } label: {
                        Text("Sign up")
                            .foregroundColor(Color.blue)
                    }
                    
                }
                Spacer()
            }
            .padding()
            .onChange(of: viewModel.isCorrect, perform: { newValue in
                dismiss()
            })
            .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
                if(viewModel.alertTitle == "Verification Error") {
                    Button("Send again", role: .none) {
                        Task {
                            await viewModel.sendVerificationEmail()
                        }
                    }
                }
                Button("Ok", role: .cancel, action: { viewModel.logout() })
            } message: {
                Text(viewModel.alertText)
            }
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

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: AuthViewModel(isLogin: true, userService: MockUserService(), sessionService: MockSessionService(currentUser: nil), imageService: MockImageService()))
    }
}
