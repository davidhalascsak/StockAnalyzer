import Foundation
import FirebaseFirestore
import SwiftUI

@MainActor
class FeedViewModel: ObservableObject {
    @Published var posts = [Post]()
    @Published var isNewPostPresented: Bool = false
    @Published var isSettingsPresented: Bool = false
    @Published var shouldScroll: Bool = false
    @Published var isLoading: Bool = false
    @Published var reloadCounter: Int = 0
    
    let userService: UserServiceProtocol
    let postService: PostServiceProtocol
    
    init(userService: UserServiceProtocol, postService: PostServiceProtocol) {
        self.userService = userService
        self.postService = postService
    }
    
    func fetchPosts() async {
        self.posts = await postService.fetchPosts(symbol: nil)

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
