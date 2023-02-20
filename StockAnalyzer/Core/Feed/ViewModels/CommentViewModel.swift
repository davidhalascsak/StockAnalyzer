import Foundation
import SwiftUI

class CommentViewModel: ObservableObject {
    @Published var post: Post
    @Published var comment: Comment
    
    let commentService = CommentService()
    
    init(post: Post, comment: Comment) {
        self.post = post
        self.comment = comment
        checkIfCommentIsLiked()
    }
    
    func likeComment() {
        commentService.likeComment(post: self.post, comment: self.comment) {
            self.comment.likes += 1
            withAnimation(.easeIn(duration: 0.3)) {
                self.comment.isLiked = true
            }
        }
    }
    
    func unlikeComment() {
        commentService.unlikeComment(post: self.post, comment: self.comment) {
            self.comment.likes -= 1
            withAnimation(.easeIn(duration: 0.3)) {
                self.comment.isLiked = false
            }
        }
    }
    
    func checkIfCommentIsLiked() {
        commentService.checkIfCommentIsLiked(comment: self.comment) { isLiked in
            self.comment.isLiked = isLiked
        }
    }
}
