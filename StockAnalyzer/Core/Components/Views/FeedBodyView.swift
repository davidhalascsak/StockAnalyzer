import SwiftUI

struct FeedBodyView: View {
    @StateObject var viewModel: FeedViewModel
    @Binding var isNewPostPresented: Bool
    
    init(symbol: String?, isNewPostPresented: Binding<Bool>, userService: UserServiceProtocol, postService: PostServiceProtocol, sessionService: SessionServiceProtocol, imageService: ImageServiceProtocol) {
        _viewModel = StateObject(wrappedValue: FeedViewModel(symbol: symbol, userService: userService, postService: postService, sessionService: sessionService, imageService: imageService))
        _isNewPostPresented = isNewPostPresented
    }
    
    var body: some View {
        LazyVStack {
            if !viewModel.isLoading {
                ForEach(viewModel.posts) { post in
                    PostView(post: post, postService: PostService(), sessionService: SessionService())
                    Divider()
                }
            } else {
                Spacer()
                ProgressView()
                Spacer()
            }
        }
        .task {
            viewModel.isLoading = true
            await viewModel.fetchPosts()
        }
        .onChange(of: isNewPostPresented) { newValue in
            if newValue == false {
                Task {
                    viewModel.isLoading = true
                    await viewModel.fetchPosts()
                }
            }
        }
    }
}

struct FeedBodyView_Previews: PreviewProvider {
    @State static var isNewPostPresented: Bool = false
    
    static var previews: some View {
        FeedBodyView(symbol: "Apple", isNewPostPresented: $isNewPostPresented, userService: UserService(), postService: PostService(), sessionService: MockSessionService(currentUser: nil), imageService: ImageService())
    }
}
