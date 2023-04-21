import Foundation

@MainActor
class NewsViewModel: ObservableObject  {
    @Published var news: [News] = []
    @Published var shouldScroll: Bool = false
    @Published var isLoading: Bool = false
    
    private let newsService: NewsServiceProtocol
    
    init(newsService: NewsServiceProtocol) {
        self.newsService = newsService
    }
    
    func fetchNews() async {
        let fetchedNews = await newsService.fetchData()
        self.news = sortNews(news: fetchedNews)
        
        self.isLoading = false
    }

    func sortNews(news: [News]) -> [News] {
        return news.sorted {
            $0.date > $1.date
        }
    }
    
    static func createDate(timestamp: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM y HH:mm:ss z"
        
        let date = formatter.date(from: timestamp)
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        
        if let date = date {
            return formatter.string(from: date)
        }
        return "unknown date"
    }
}
