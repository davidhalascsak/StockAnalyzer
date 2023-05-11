import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                TextField("username", text: $viewModel.userData.username)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)
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
                SecureField("confirm password", text: $viewModel.userData.passwordAgain)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)
                Picker("Country", selection: $viewModel.userData.location) {
                    ForEach(viewModel.countries, id: \.self) {
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
                        await viewModel.checkRegistration()
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
                            viewModel.isLogin.toggle()
                            viewModel.alertText = ""
                            viewModel.alertTitle = ""
                            viewModel.userData.username = ""
                            viewModel.userData.email = ""
                            viewModel.userData.password = ""
                            viewModel.userData.passwordAgain = ""
                            viewModel.userData.location = "Hungary"
                        }
                    } label: {
                        Text("Sign in")
                            .foregroundColor(Color.green)
                    }
                }
                Spacer()
            }
            .padding()
            .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert, actions: {
                Button("Ok", role: .cancel, action: {
                    if viewModel.isCorrect {
                        viewModel.isCorrect.toggle()
                        dismiss()
                    }
                })
            }, message: {
                Text(viewModel.alertText)
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

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(viewModel: AuthViewModel(isLogin: false, userService: MockUserService(), sessionService: MockSessionService(currentUser: nil), imageService: MockImageService()))
    }
}
