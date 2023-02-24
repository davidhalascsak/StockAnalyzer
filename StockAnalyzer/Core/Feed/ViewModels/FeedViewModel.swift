import Foundation
import FirebaseFirestore
import SwiftUI


class FeedViewModel: ObservableObject {
    @Published var posts = [Post]()
    @Published var isNewPostPresented: Bool = false
    @Published var isSettingsPresented: Bool = false
    @Published var shouldScroll: Bool = false
    
    let userService = UserService()
    let postService = PostService()
    
    func fetchPosts() {
        postService.fetchPosts { posts in
            self.posts = posts
            
            for i in 0..<self.posts.count {
                self.userService.fetchUser(id: self.posts[i].userRef) { user in
                    self.posts[i].user = user
                }
            }
        }
    }
}
