import Foundation

class FeedBodyViewModel: ObservableObject {
    @Published var posts = [Post]()
    @Published var isLoading: Bool = false
    
    let symbol: String    
    let userService: UserService
    let postService: PostService
    
    init(symbol: String, userService: UserService, postService: PostService) {
        self.symbol = symbol
        self.userService = userService
        self.postService = postService
    }
    
    func fetchPosts() async {
        self.isLoading = true
        self.posts = await postService.fetchPosts(symbol: self.symbol)

        for i in 0..<(self.posts.count) {
            let user = await self.userService.fetchUser(id: self.posts[i].userRef)
            
            if let user = user {
                self.posts[i].user = user
                self.posts[i].isLiked = await self.postService.checkIfPostIsLiked(post: (self.posts[i]))
            }
        }
        self.isLoading = false
    }
}
