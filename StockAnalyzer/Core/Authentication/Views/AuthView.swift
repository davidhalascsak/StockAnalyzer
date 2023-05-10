import SwiftUI

struct AuthView: View {
    @StateObject private var viewModel: AuthViewModel
    
    init(isLogin: Bool, userService: UserServiceProtocol, sessionService: SessionServiceProtocol, imageService: ImageServiceProtocol) {
        _viewModel = StateObject(wrappedValue: AuthViewModel(isLogin: isLogin, userService: userService, sessionService: sessionService, imageService: imageService))
    }
    
    var body: some View {
        if viewModel.isLogin {
            SignInView(viewModel: viewModel)
        } else {
            SignUpView(viewModel: viewModel)
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(isLogin: true, userService: MockUserService(), sessionService: MockSessionService(currentUser: nil), imageService: MockImageService())
    }
}


