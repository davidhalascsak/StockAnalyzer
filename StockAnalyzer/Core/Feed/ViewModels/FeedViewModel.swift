import Foundation
import FirebaseFirestore
import SwiftUI


class FeedViewModel: ObservableObject {
    @Published var posts = [Post]()
    let userService = UserService()
    let postService = PostService()
    init() {
        fetchPosts()
    }
    
    func fetchPosts() {
        postService.fetchPosts { posts in
            self.posts = posts
            
            for i in 0..<self.posts.count {
                self.userService.fetchUserFromReference(ref: self.posts[i].userRef ?? nil) { user in
                    self.posts[i].user = user
                }
            }
        }
    }
}
