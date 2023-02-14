import Foundation

class PostViewModel: ObservableObject {
    @Published var post: Post
    var commentService = CommentService()
    var userService = UserService()
    
    init(post: Post) {
        self.post = post
    }
    
    func fetchComments() {
        self.post.comments = []
        for i in 0..<self.post.commentsRef.count {
            commentService.FetchComment(ref: self.post.commentsRef[i]) { comment in
                var tempComment = comment
                let j = self.post.comments?.firstIndex(where:{ elem in
                    elem.id == tempComment.id
                })
                
                self.userService.fetchUserFromReference(ref: tempComment.userRef) { user in
                    tempComment.user = user
                    if let j = j {
                        self.post.comments?[j] = tempComment
                    } else {
                        self.post.comments?.append(tempComment)
                    }
                }
            }
        }
    }
}
