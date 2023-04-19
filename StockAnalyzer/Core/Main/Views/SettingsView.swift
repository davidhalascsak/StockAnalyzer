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
                HStack {
                    if vm.sessionService.getUserId() != nil {
                        PhotosPicker(selection: $vm.selectedPhoto,  matching: .images) {
                            if let imageData = vm.user?.image {
                                let image = UIImage(data: imageData)
                                if let image = image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(1.0, contentMode: .fit)
                                        .cornerRadius(10)
                                } else {
                                    Image("default_avatar")
                                        .resizable()
                                        .aspectRatio(1.0, contentMode: .fit)
                                        .cornerRadius(10)
                                }
                            }
                        }
                        .onChange(of: vm.selectedPhoto) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    //profileImage = UIImage(data: data)
                                }
                            }
                        }
                    }
                    Text("\(vm.user?.username ?? "No user")")
                        .font(.title)
                    Spacer()
                }
                .padding()
                .frame(height: 100)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(20)
                
                if vm.sessionService.getUserId() != nil {
                    Text("Sign out")
                        .font(.title)
                        .padding(.vertical)
                        .onTapGesture {
                            if vm.sessionService.logout() {
                                vm.user = nil
                            }
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
        }
        .task({
            await vm.fetchUser()
        })
    }
}

struct SettingsView_Previews: PreviewProvider {
    
    static var previews: some View {
        SettingsView(userService: UserService(), sessionService: SessionService(), imageService: ImageService())
    }
}
