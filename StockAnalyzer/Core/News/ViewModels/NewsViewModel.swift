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
        self.news = await newsService.fetchData()
        self.sortNews()
        
        self.isLoading = false
    }

    func sortNews() {
        self.news = self.news.sorted {
            $0.date > $1.date
        }
    }
}
