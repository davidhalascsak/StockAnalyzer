import SwiftUI

struct FeedBodyView: View {
    @StateObject var vm: FeedBodyViewModel
    @Binding var isNewPostPresented: Bool
    
    init(symbol: String?, isNewPostPresented: Binding<Bool>, userService: UserServiceProtocol, postService: PostServiceProtocol, imageService: ImageServiceProtocol) {
        _vm = StateObject(wrappedValue: FeedBodyViewModel(symbol: symbol, userService: userService, postService: postService, imageService: imageService))
        _isNewPostPresented = isNewPostPresented
    }
    
    var body: some View {
        LazyVStack {
            if !vm.isLoading {
                ForEach(vm.posts) { post in
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
            vm.isLoading = true
            await vm.fetchPosts()
        }
        .onChange(of: isNewPostPresented) { newValue in
            if newValue == false {
                Task {
                    vm.isLoading = true
                    await vm.fetchPosts()
                }
            }
        }
    }
}

struct FeedBodyView_Previews: PreviewProvider {
    @State static var isNewPostPresented: Bool = false
    
    static var previews: some View {
        FeedBodyView(symbol: "Apple", isNewPostPresented: $isNewPostPresented, userService: UserService(), postService: PostService(), imageService: ImageService())
    }
}
