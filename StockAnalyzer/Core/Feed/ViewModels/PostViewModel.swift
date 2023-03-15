import Foundation
import SwiftUI

class PostViewModel: ObservableObject {
    @Published var post: Post
    var postService = PostService()
    
    init(post: Post) {
        self.post = post
    }
    
    func likePost() {
        postService.likePost(post: post) { [weak self] in
            self?.post.likes += 1
            withAnimation(.easeIn(duration: 0.3)) {
                self?.post.isLiked = true
            }
        }
    }
    
    func unlikePost() {
        postService.unlikePost(post: post) { [weak self] in
            self?.post.likes -= 1
            withAnimation(.easeOut(duration: 0.3)) {
                self?.post.isLiked = false
            }
        }
    }
}
