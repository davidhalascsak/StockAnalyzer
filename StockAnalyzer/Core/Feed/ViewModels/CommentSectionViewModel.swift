import Foundation
import Firebase

@MainActor
class CommentSectionViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var comments: [Comment] = []
    @Published var commentBody: String = ""
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertText: String = ""
    
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

        for i in 0..<comments.count {
            let userRef = comments[i].userRef
            let user = await userService.fetchUser(id: userRef)
            
            if let user = user {
                comments[i].user = user
                
                let comment = comments[i]
                comments[i].isLiked = await commentService.checkIfCommentIsLiked(comment: comment)
            }
        }
        
        self.isLoading = false
    }
    
    func createComment() async {
        let result = await commentService.createComment(post: post, body: commentBody)
        if result {
            await fetchComments()
        } else {
            showAlert.toggle()
            alertTitle = "Error"
            alertText = "Error while adding the comment."
        }
        commentBody = ""
    }
}
