import Foundation
import Combine

class NewsViewModel: ObservableObject  {
    @Published var news: [News] = []
    @Published var isLoading: Bool = false
    
    private let newsService = NewsService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscription()
    }
    
    
    func addSubscription() {
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
        newsService.getNews()
    }
    
    func sortNews(news: [News]) -> [News] {
        return news.sorted {
            $0.pubDate > $1.pubDate
        }
    }
    
    static func createDate(timestamp: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let date = formatter.date(from: timestamp)
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        
        if let date = date {
            return formatter.string(from: date)
        }
        return "unknown date"
    }
}
