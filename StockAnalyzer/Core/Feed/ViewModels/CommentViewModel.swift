import Foundation
import SwiftUI

@MainActor
class CommentViewModel: ObservableObject {
    @Published var post: Post
    @Published var comment: Comment
    @Published var isUpdated: Bool = true
    
    var commentService: CommentServiceProtocol
    let sessionService: SessionServiceProtocol
    
    init(post: Post, comment: Comment, commentService: CommentServiceProtocol, sessionService: SessionServiceProtocol) {
        self.post = post
        self.comment = comment
        self.commentService = commentService
        self.sessionService = sessionService
    }
    
    func likeComment() async {
        isUpdated = false
        let result = await commentService.likeComment(post: self.post, comment: self.comment)
        
        if result {
            self.comment.likes += 1
            
            withAnimation(.easeIn(duration: 0.3)) {
                self.comment.isLiked = true
            }
        }
        
        isUpdated = true
    }
    
    func unlikeComment() async {
        isUpdated = false
        let result = await commentService.unlikeComment(post: self.post, comment: self.comment)
        
        if result {
            self.comment.likes -= 1
            
            withAnimation(.easeIn(duration: 0.3)) {
                self.comment.isLiked = false
            }
            isUpdated = true
        }
    }
}
