import Foundation
import SwiftUI

class PostViewModel: ObservableObject {
    @Published var post: Post
    var postService = PostService()
    
    init(post: Post) {
        self.post = post
        checkIfPostIsLiked()
    }
    
    func likePost() {
        postService.likePost(post: post) {
            self.post.likes += 1
            withAnimation(.easeIn(duration: 0.3)) {
                self.post.isLiked = true
            }
        }
    }
    
    func unlikePost() {
        postService.unlikePost(post: post) {
            self.post.likes -= 1
            withAnimation(.easeOut(duration: 0.3)) {
                self.post.isLiked = false
            }
        }
    }
    
    func checkIfPostIsLiked() {
        postService.checkIfPostIsLiked(post: self.post) { isLiked in
            self.post.isLiked = isLiked
        }
    }
}
