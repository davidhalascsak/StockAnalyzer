import Foundation
import Firebase

class CommentSectionViewModel: ObservableObject {
    @Published var post: Post
    @Published var comments: [Comment] = []
    
    let commentService = CommentService()
    let userService = UserService()
    
    init(post: Post) {
        self.post = post
    }
    
    func fetchComments() {
        commentService.fetchComments(post: post) { [weak self] comments in
            self?.comments = comments
            
            for i in 0..<(self?.comments.count ?? 0) {
                self?.userService.fetchUser(id: self?.comments[i].userRef ?? "") { user in
                    self?.comments[i].user = user
                }
            }
        }
    }
    
    func createComment(body: String) {
        commentService.createComment(post: self.post, body: body) { [weak self] in
            self?.fetchComments()
        }
    }
}