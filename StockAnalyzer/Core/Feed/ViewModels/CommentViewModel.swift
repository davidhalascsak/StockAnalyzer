import Foundation
import SwiftUI

@MainActor
class CommentViewModel: ObservableObject {
    @Published var post: Post
    @Published var comment: Comment
    
    var commentService: CommentServiceProtocol
    
    init(post: Post, comment: Comment, commentService: CommentServiceProtocol) {
        self.post = post
        self.comment = comment
        self.commentService = commentService
    }
    
    func likeComment() async {
        await commentService.likeComment(post: self.post, comment: self.comment)
        self.comment.likes += 1
        
        withAnimation(.easeIn(duration: 0.3)) {
            self.comment.isLiked = true
        }
    }
    
    func unlikeComment() async {
        await commentService.unlikeComment(post: self.post, comment: self.comment)
        self.comment.likes -= 1
        
        withAnimation(.easeIn(duration: 0.3)) {
            self.comment.isLiked = false
        }
    }
}
