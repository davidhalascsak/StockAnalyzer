import Foundation

class PostViewModel: ObservableObject {
    var post: Post
    var userService = UserService()
    
    init(post: Post) {
        self.post = post
    }
    
    func updateLikes() {
        userService.updateLikes(post: post)
    }
}
