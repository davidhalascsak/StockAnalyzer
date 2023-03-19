import Foundation
import Combine

class NewsViewModel: ObservableObject  {
    @Published var news: [News] = []
    @Published var shouldScroll: Bool = false
    @Published var isLoading: Bool = false
    
    private let newsService: NewsService
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.newsService = NewsService(symbol: nil)
        self.isLoading = true
        
        fetchData()
    }
    
    
    func fetchData() {
        newsService.$allNews
            .map(sortNews)
            .sink { [weak self] (returnedNews) in
                self?.news = returnedNews
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }

    func reloadData() {
        isLoading = true
        newsService.fetchData()
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
