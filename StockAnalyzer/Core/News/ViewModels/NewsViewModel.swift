import Foundation

@MainActor
class NewsViewModel: ObservableObject  {
    @Published var news: [News] = []
    @Published var shouldScroll: Bool = false
    @Published var isLoading: Bool = true
    
    private let newsService: NewsServiceProtocol
    
    init(newsService: NewsServiceProtocol) {
        self.newsService = newsService
    }
    
    func fetchNews() async {
        news = await newsService.fetchData()
        sortNews()
        
        isLoading = false
    }

    func sortNews() {
        news = news.sorted {
            $0.date > $1.date
        }
    }
}
