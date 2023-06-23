import Foundation
import FirebaseFirestore
import SwiftUI

@MainActor
class FeedViewModel: ObservableObject {
    @Published var posts: [Post] = [Post]()
    @Published var shouldScroll: Bool = false
    @Published var isLoading: Bool = false
    
    let stockSymbol: String?
    let userService: UserServiceProtocol
    let postService: PostServiceProtocol
    let sessionService: SessionServiceProtocol
    let imageService: ImageServiceProtocol
    
    init(stockSymbol: String?, userService: UserServiceProtocol, postService: PostServiceProtocol, sessionService: SessionServiceProtocol, imageService: ImageServiceProtocol) {
        self.stockSymbol = stockSymbol
        self.userService = userService
        self.postService = postService
        self.sessionService = sessionService
        self.imageService = imageService
    }
    
    func fetchPosts() async {
        posts = await postService.fetchPosts(stockSymbol: stockSymbol)

        for i in 0..<(posts.count) {
            var user: User?
            if posts.indices.contains(i) {
                let userRef = posts[i].userRef
                user = await userService.fetchUser(id: userRef)
            }
            
            if let user = user {
                if posts.indices.contains(i) {
                    self.posts[i].user = user
                }
                
                var post: Post?
                if posts.indices.contains(i) {
                    post = posts[i]
                }
                
                if let post = post {
                    let isLiked = await postService.checkIfPostIsLiked(post: post)
                    
                    if posts.indices.contains(i) {
                        posts[i].isLiked = isLiked
                    }
                }
            }
        }
        isLoading = false
    }
}
