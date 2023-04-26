import Foundation

@MainActor
class NewPostViewModel: ObservableObject {
    @Published var postBody: String = ""
    @Published var alertTitle: String = ""
    @Published var alertText: String = ""
    @Published var showAlert: Bool = false
    
    let symbol: String?
    let postService: PostServiceProtocol
    
    init(symbol: String?, postService: PostServiceProtocol) {
        self.symbol = symbol
        self.postService = postService
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
