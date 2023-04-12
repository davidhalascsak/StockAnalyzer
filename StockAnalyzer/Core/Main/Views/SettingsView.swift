import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @EnvironmentObject var sessionService: SessionService
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: SettingsViewModel
    
    @State var isLoginPresented: Bool = false
    @State var isSignupPresented: Bool = false
    
    init(userService: UserService, sessionService: SessionServiceProtocol) {
        _vm = ObservedObject(wrappedValue: SettingsViewModel(userService: userService, sessionService: SessionService()))
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack {
                    Circle()
                        .frame(width: 50, height: 50)
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
                            try! Auth.auth().signOut()
                            Task {
                                await vm.fetchUser()
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
        SettingsView(userService: UserService(), sessionService: SessionService())
    }
}
