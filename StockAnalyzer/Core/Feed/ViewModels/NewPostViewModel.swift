import Foundation

@MainActor
class NewPostViewModel: ObservableObject {
    @Published var postBody: String = ""
    @Published var alertTitle: String = ""
    @Published var alertText: String = ""
    @Published var showAlert: Bool = false
    
    let stockSymbol: String?
    let postService: PostServiceProtocol
    
    init(stockSymbol: String?, postService: PostServiceProtocol) {
        self.stockSymbol = stockSymbol
        self.postService = postService
    }
    
    func createPost() async {
        let result = await postService.createPost(body: postBody, stockSymbol: stockSymbol)
        if result == false {
            showAlert.toggle()
            alertTitle = "Error"
            alertText = "Error while creating the post."
        }
        postBody = ""
    }
}
