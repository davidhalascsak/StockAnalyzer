import Foundation
import Combine


class StockViewModel: ObservableObject {
    @Published var companyProfile: Company?
    @Published var news: [News] = []
    @Published var isDownloadingNews: Bool = false
    
    let symbol: String
    //let stockService: StockService
    let newsService: NewsService
    
    var cancellables = Set<AnyCancellable>()
    
    init(symbol: String) {
        self.symbol = symbol
        //self.stockService = StockService(symbol: symbol)
        self.newsService = NewsService(symbol: symbol)
        self.isDownloadingNews = true
        addSubscribers()
    }
    
    
    func addSubscribers() {
//        self.stockService.$companyInformation
//            .sink { [weak self] (companyProfile) in
//                self?.companyProfile = companyProfile ?? nil
//            }
//            .store(in: &cancellables)
        
        self.newsService.$allNews
            .sink { [weak self] (news) in
                if news.count > 10 {
                    self?.news = Array(news[0..<10])
                } else {
                    self?.news = news
                }
                self?.isDownloadingNews = false
            }
            .store(in: &cancellables)
    }
    
    func decreaseInPercentage(price: Double, change: Double) -> String {
        let result = (change / price) * 100
        let addition = change >= 0 ? "+" : ""
        
        return "\(addition)\(String(format: "%.2f", result))"
    }
    
    func createDate(timestamp: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "US_POSIX")
        formatter.dateFormat = "E, d MMM y HH:mm:ss z"
        

        let date = formatter.date(from: timestamp)
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = date {
            return formatter.string(from: date)
        }
        return "unknown date"
    }
     
}
