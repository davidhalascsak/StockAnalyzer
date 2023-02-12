import Foundation

class PostViewModel: ObservableObject {
    @Published var post: Post
    var commentService = CommentService()
    var userService = UserService()
    
    init(post: Post) {
        self.post = post
        fetchComments(post: self.post)
    }
    
    func fetchComments(post: Post) {
        self.post.comments = []
        for i in 0..<self.post.commentsRef.count {
            commentService.FetchComments(ref: self.post.commentsRef[i]) { comment in
                var tempComment = comment
                self.userService.fetchUserFromReference(ref: tempComment.userRef) { user in
                    tempComment.user = user
                    self.post.comments?.append(tempComment)
                }
            }
            
        }
    }
}
