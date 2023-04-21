import Foundation

class NewPostViewModel: ObservableObject {
    @Published var textContent: String = ""
    let symbol: String?
    
    let postService: PostServiceProtocol
    
    init(symbol: String?, postService: PostServiceProtocol) {
        self.symbol = symbol
        self.postService = postService
    }
    
    func createPost() async {
        await postService.createPost(body: textContent, symbol: symbol)
    }
    
}
