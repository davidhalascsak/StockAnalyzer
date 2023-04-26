import Foundation

@MainActor
class FeedBodyViewModel: ObservableObject {
    @Published var posts = [Post]()
    @Published var isLoading: Bool = false
    
    let symbol: String?
    let userService: UserServiceProtocol
    let postService: PostServiceProtocol
    let imageService: ImageServiceProtocol
    
    init(symbol: String?, userService: UserServiceProtocol, postService: PostServiceProtocol, imageService: ImageServiceProtocol) {
        self.symbol = symbol
        self.userService = userService
        self.postService = postService
        self.imageService = imageService
    }
    
    func fetchPosts() async {
        posts = await postService.fetchPosts(symbol: symbol)

        for i in 0..<(posts.count) {
            let userRef = posts[i].userRef
            
            let user = await userService.fetchUser(id: userRef)
            
            if let user = user {
                posts[i].user = user
                posts[i].user?.image = await imageService.fetchImageData(url: user.imageUrl)
                
                let post = posts[i]
                posts[i].isLiked = await postService.checkIfPostIsLiked(post: post)
            }
        }
        isLoading = false
    }
}
