import Foundation

@MainActor
class FeedBodyViewModel: ObservableObject {
    @Published var posts = [Post]()
    @Published var isLoading: Bool = false
    
    let symbol: String?
    let userService: UserServiceProtocol
    let postService: PostServiceProtocol
    
    init(symbol: String?, userService: UserServiceProtocol, postService: PostServiceProtocol) {
        self.symbol = symbol
        self.userService = userService
        self.postService = postService
    }
    
    func fetchPosts() async {
        self.posts = await postService.fetchPosts(symbol: symbol)

        for i in 0..<(self.posts.count) {
            let userRef = self.posts[i].userRef
            let user = await self.userService.fetchUser(id: userRef)
            
            if let user = user {
                self.posts[i].user = user
                
                let post = self.posts[i]
                self.posts[i].isLiked = await self.postService.checkIfPostIsLiked(post: post)
            }
        }
        self.isLoading = false
    }
}
