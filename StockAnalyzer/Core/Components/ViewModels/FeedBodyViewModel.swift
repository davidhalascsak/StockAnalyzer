import Foundation

class FeedBodyViewModel: ObservableObject {
    @Published var posts = [Post]()
    @Published var isLoading: Bool
    
    let symbol: String
    
    let userService = UserService()
    let postService = PostService()
    
    
    init(symbol: String) {
        self.symbol = symbol
        self.isLoading = true
    }
    
    func fetchPosts() {
        postService.fetchPosts(symbol: symbol) { [weak self] posts in
            self?.posts = posts
            
            for i in 0..<(self?.posts.count ?? 0) {
                self?.userService.fetchUser(id: self?.posts[i].userRef ?? "") { user in
                    self?.posts[i].user = user
                }
            }
            self?.isLoading = false
        }
        
    }
}
