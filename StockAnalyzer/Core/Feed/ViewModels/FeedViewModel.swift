import Foundation
import FirebaseFirestore
import SwiftUI

@MainActor
class FeedViewModel: ObservableObject {
    @Published var posts: [Post] = [Post]()
    @Published var shouldScroll: Bool = false
    @Published var isLoading: Bool = true
    @Published var showAlert: Bool = false
    @Published var postBody: String = ""
    @Published var alertTitle: String = ""
    @Published var alertText: String = ""
    
    let symbol: String?
    let userService: UserServiceProtocol
    let postService: PostServiceProtocol
    let sessionService: SessionServiceProtocol
    let imageService: ImageServiceProtocol
    
    init(symbol: String?, userService: UserServiceProtocol, postService: PostServiceProtocol, sessionService: SessionServiceProtocol, imageService: ImageServiceProtocol) {
        self.userService = userService
        self.postService = postService
        self.sessionService = sessionService
        self.imageService = imageService
    }
    
    func fetchPosts() async {
        posts = await postService.fetchPosts(symbol: nil)

        for i in 0..<(posts.count) {
            let userRef = posts[i].userRef
            
            let user = await userService.fetchUser(id: userRef)
            
            if let user = user {
                self.posts[i].user = user
                self.posts[i].user?.image = await imageService.fetchImageData(url: user.imageUrl)
                
                let post = posts[i]
                posts[i].isLiked = await postService.checkIfPostIsLiked(post: post)
            }
        }
        isLoading = false
    }
    
    func createPost() async {
        let result = await postService.createPost(body: postBody, symbol: symbol)
        if result == false {
            showAlert.toggle()
            alertTitle = "Error"
            alertText = "Error while creating the post."
        }
        postBody = ""
    }
}
