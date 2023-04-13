import Foundation
import SwiftUI

@MainActor
class PostViewModel: ObservableObject {
    @Published var post: Post
    
    var postService: PostServiceProtocol
    let sessionService: SessionServiceProtocol
    
    init(post: Post, postService: PostServiceProtocol, sessionService: SessionServiceProtocol) {
        self.post = post
        self.postService = postService
        self.sessionService = sessionService
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
