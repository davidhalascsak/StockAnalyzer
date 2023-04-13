import Foundation
import Firebase

@MainActor
class CommentSectionViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    
    let post: Post
    var commentService: CommentServiceProtocol
    let userService: UserServiceProtocol
    let sessionService: SessionServiceProtocol
    
    init(post: Post, commentService: CommentServiceProtocol, userService: UserServiceProtocol, sessionService: SessionServiceProtocol) {
        self.post = post
        self.commentService = commentService
        self.userService = userService
        self.sessionService = sessionService
    }
    
    func fetchComments() async {
        self.comments = await commentService.fetchComments(post: post)

        for i in 0..<self.comments.count {
            let userRef = self.comments[i].userRef
            let user = await self.userService.fetchUser(id: userRef)
            
            if let user = user {
                self.comments[i].user = user
                
                let comment = self.comments[i]
                self.comments[i].isLiked = await self.commentService.checkIfCommentIsLiked(comment: comment)
            }
        }
    }
    
    func createComment(body: String) async {
        await commentService.createComment(post: self.post, body: body)
        await self.fetchComments()
    }
}
