import SwiftUI
import PhotosUI
import FirebaseAuth

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: SettingsViewModel
    
    @State var isLoginPresented: Bool = false
    @State var isSignupPresented: Bool = false
    
    init(userService: UserService, sessionService: SessionServiceProtocol, imageService: ImageServiceProtocol) {
        _vm = ObservedObject(wrappedValue: SettingsViewModel(userService: userService, sessionService: sessionService, imageService: imageService))
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                header
                if vm.sessionService.getUserId() != nil {
                    Text("Sign out")
                        .font(.title)
                        .padding(.vertical)
                        .onTapGesture {
                            vm.logout()
                        }
                } else {
                    Text("Sign in")
                        .font(.title)
                        .padding(.vertical)
                        .onTapGesture {
                            isLoginPresented.toggle()
                        }
                    Text("Sign up")
                        .font(.title)
                        .onTapGesture {
                            isSignupPresented.toggle()
                        }
                }
                Spacer()
            }
            .navigationDestination(isPresented: $isLoginPresented, destination: {
                StartView(isLogin: true)
            })
            .navigationDestination(isPresented: $isSignupPresented, destination: {
                StartView(isLogin: false)
            })
            .padding()
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
            .onChange(of: isLoginPresented) { newValue in
                if newValue == false {
                    Task {
                        await vm.fetchUser()
                    }
                }
            }
            .onChange(of: isSignupPresented) { newValue in
                if newValue == false {
                    Task {
                        await vm.fetchUser()
                    }
                }
            }
            .alert(vm.alertTitle, isPresented: $vm.showAlert) {
                Button("Ok", role: .cancel) {
                    vm.alertTitle = ""
                    vm.alertText = ""
                }
            } message: {
                Text(vm.alertText)
            }
        }
        .task({
            await vm.fetchUser()
        })
    }
    
    var header: some View {
        HStack {
            if vm.isLoading == false {
                if let user = vm.user {
                    if !vm.isUpdatingProfile {
                        PhotosPicker(selection: $vm.selectedPhoto,  matching: .images) {
                            ImageView(url: user.imageUrl, defaultImage: "default_avatar", imageService: ImageService())
                                .frame(width: 60)
                                .aspectRatio(1.0, contentMode: .fit)
                                .cornerRadius(10)
                        }
                        .onChange(of: vm.selectedPhoto) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    vm.isUpdatingProfile = true
                                    Task {
                                        await vm.updatePicture(data: data)
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
                ProgressView()
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
        SettingsView(userService: UserService(), sessionService: SessionService(), imageService: ImageService())
    }
}
