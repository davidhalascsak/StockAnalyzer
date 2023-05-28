import Foundation
import Firebase

@MainActor
class CommentSectionViewModel: ObservableObject {
    @Published var comments: [Comment] = [Comment]()
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    @Published var commentBody: String = ""
    @Published var alertTitle: String = ""
    @Published var alertText: String = ""
    
    let post: Post
    var commentService: CommentServiceProtocol
    let userService: UserServiceProtocol
    let sessionService: SessionServiceProtocol
    let imageService: ImageServiceProtocol
    
    init(post: Post, commentService: CommentServiceProtocol, userService: UserServiceProtocol, sessionService: SessionServiceProtocol, imageService: ImageServiceProtocol) {
        self.post = post
        self.commentService = commentService
        self.userService = userService
        self.sessionService = sessionService
        self.imageService = imageService
    }
    
    func fetchComments() async {
        self.comments = await commentService.fetchComments(post: post)

        for i in 0..<comments.count {
            let userRef = comments[i].userRef
            let user = await userService.fetchUser(id: userRef)
            
            if let user = user {
                comments[i].user = user
                self.comments[i].user?.image = await imageService.fetchImageData(url: user.imageUrl)
                
                let comment = comments[i]
                comments[i].isLiked = await commentService.checkIfCommentIsLiked(comment: comment)
            }
        }
        
        self.isLoading = false
    }
    
    func createComment() async {
        let result = await commentService.createComment(post: post, body: commentBody)
        if result {
            isLoading = true
            await fetchComments()
            isLoading = false
        } else {
            showAlert.toggle()
            alertTitle = "Error"
            alertText = "Error while adding the comment."
        }
        commentBody = ""
    }
}
