import SwiftUI

struct FeedBodyView: View {
    @StateObject var vm: FeedBodyViewModel
    @Binding var isNewViewPresented: Bool
    
    init(symbol: String, isNewViewPresented: Binding<Bool>, userService: UserService, postService: PostService) {
        _vm = StateObject(wrappedValue: FeedBodyViewModel(symbol: symbol, userService: userService, postService: postService))
        _isNewViewPresented = isNewViewPresented
    }
    
    var body: some View {
        LazyVStack {
            if vm.isLoading == false {
                ForEach(vm.posts) { post in
                    PostView(post: post)
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
        .onChange(of: isNewViewPresented) { newValue in
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
    @State static var isNewViewPresented: Bool = false
    
    static var previews: some View {
        FeedBodyView(symbol: "Apple", isNewViewPresented: $isNewViewPresented, userService: UserService(), postService: PostService())
    }
}
