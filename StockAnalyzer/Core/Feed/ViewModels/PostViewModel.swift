import Foundation

class PostViewModel: ObservableObject {
    @Published var post: Post
    var commentService = CommentService()
    var userService = UserService()
    
    init(post: Post) {
        self.post = post
    }
    
    
    func fetchComments() {
        self.post.comments = [Comment]()
        
        commentService.FetchComment(post: self.post) { comments in
            self.post.comments = comments
            
            for i in 0..<(self.post.comments?.count ?? 0) {
                self.userService.fetchUserFromReference(ref: self.post.comments?[i].userRef) { user in
                    self.post.comments?[i].user = user
                }
            }
        }
    }
}
