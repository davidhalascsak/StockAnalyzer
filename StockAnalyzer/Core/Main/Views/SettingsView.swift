import SwiftUI
import PhotosUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var isSignInPresented: Bool = false
    @State private var isSignUpPresented: Bool = false
    
    @ObservedObject private var viewModel: SettingsViewModel
    
    init(userService: UserServiceProtocol, sessionService: SessionServiceProtocol, imageService: ImageServiceProtocol) {
        _viewModel = ObservedObject(wrappedValue: SettingsViewModel(userService: userService, sessionService: sessionService, imageService: imageService))
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                profileView
                if viewModel.user != nil {
                    Text("Sign out")
                        .font(.title)
                        .padding(.vertical)
                        .onTapGesture {
                            viewModel.logout()
                        }
                } else {
                    Text("Sign in")
                        .font(.title)
                        .padding(.vertical)
                        .onTapGesture {
                            isSignInPresented.toggle()
                        }
                    Text("Sign up")
                        .font(.title)
                        .onTapGesture {
                            isSignUpPresented.toggle()
                        }
                }
                Spacer()
            }
            .navigationDestination(isPresented: $isSignInPresented, destination: {
                AuthView(isLogin: true, userService: UserService(), sessionService: SessionService(), imageService: ImageService())
            })
            .navigationDestination(isPresented: $isSignUpPresented, destination: {
                AuthView(isLogin: false, userService: UserService(), sessionService: SessionService(), imageService: ImageService())
            })
            .padding()
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "xmark")
                        .onTapGesture {
                            dismiss()
                        }
                }
            }
            .onChange(of: isSignInPresented) { newValue in
                if newValue == false {
                    Task {
                        await viewModel.fetchUser()
                    }
                }
            }
            .onChange(of: isSignUpPresented) { newValue in
                if newValue == false {
                    Task {
                        await viewModel.fetchUser()
                    }
                }
            }
            .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
                Button("Ok", role: .cancel) {
                    viewModel.alertTitle = ""
                    viewModel.alertText = ""
                }
            } message: {
                Text(viewModel.alertText)
            }
        }
        .task {
            await viewModel.fetchUser()
        }
    }
    
    var profileView: some View {
        HStack {
            if viewModel.isLoading == false {
                if let user = viewModel.user {
                    if !viewModel.isUpdatingProfile {
                        PhotosPicker(selection: $viewModel.selectedPhoto,  matching: .images) {
                            ImageView(url: user.imageUrl, defaultImage: "default_avatar", imageService: ImageService())
                                .frame(width: 60)
                                .aspectRatio(1.0, contentMode: .fit)
                                .cornerRadius(10)
                        }
                        .onChange(of: viewModel.selectedPhoto) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    viewModel.isUpdatingProfile = true
                                    Task {
                                        await viewModel.updatePicture(data: data)
                                    }
                                }
                            }
                        }
                    } else {
                        ProgressView()
                            .frame(width: 60)
                    }
                    Text(user.username)
                        .font(.title)
                    Spacer()
                } else {
                    Text("No user")
                        .font(.title)
                    Spacer()
                }
            } else {
                Spacer()
                ProgressView()
                Spacer()
            }
        }
        .padding()
        .frame(height: 100)
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(20)
    }
}

struct SettingsView_Previews: PreviewProvider {
    
    static var previews: some View {
        SettingsView(userService: MockUserService(), sessionService: MockSessionService(currentUser: nil), imageService: MockImageService())
    }
}
