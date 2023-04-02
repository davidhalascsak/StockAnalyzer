import Foundation
import SwiftUI

@MainActor
class PostViewModel: ObservableObject {
    @Published var post: Post
    var postService: PostServiceProtocol
    
    init(post: Post, postService: PostServiceProtocol) {
        self.post = post
        self.postService = postService
    }
    
    func likePost() async {
        await postService.likePost(post: post)
        self.post.likes += 1
        
        withAnimation(.easeIn(duration: 0.3)) {
            self.post.isLiked = true
        }
    }
    
    func unlikePost() async {
        await postService.unlikePost(post: post)
        self.post.likes -= 1
        
        withAnimation(.easeIn(duration: 0.3)) {
            self.post.isLiked = false
        }
    }
}
