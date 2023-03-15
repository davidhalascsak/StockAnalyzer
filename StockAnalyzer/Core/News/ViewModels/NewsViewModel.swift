import Foundation
import Combine

class NewsViewModel: ObservableObject  {
    @Published var news: [News] = []
    @Published var shouldScroll: Bool = false
    @Published var isLoading: Bool = false
    
    private let newsService = NewsService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.isLoading = true
        addSubscription()
    }
    
    
    func addSubscription() {
        newsService.$allNews
            .map(sortNews)
            .sink { [weak self] (returnedNews) in
                self?.news = returnedNews
                self?.isLoading = false
                print("end")
            }
            .store(in: &cancellables)
    }

    func reloadData() {
        isLoading = true
        newsService.getNews()
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
