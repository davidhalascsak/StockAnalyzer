import Foundation
import SwiftUI

@MainActor
class PostViewModel: ObservableObject {
    @Published var isUpdated: Bool = true
    @Published var post: Post
    
    var postService: PostServiceProtocol
    let sessionService: SessionServiceProtocol
    
    init(post: Post, postService: PostServiceProtocol, sessionService: SessionServiceProtocol) {
        self.post = post
        self.postService = postService
        self.sessionService = sessionService
    }
    
    func likePost() async {
        isUpdated = false
        let result = await postService.likePost(post: post)
        if result {
            self.post.likes += 1
            
            withAnimation(.easeIn(duration: 0.3)) {
                self.post.isLiked = true
            }
        }
        
        isUpdated = true
    }
    
    func unlikePost() async {
        isUpdated = false
        let result = await postService.unlikePost(post: post)
        if result {
            self.post.likes -= 1
            
            withAnimation(.easeIn(duration: 0.3)) {
                self.post.isLiked = false
            }
        }
       
        isUpdated = true
    }
}
