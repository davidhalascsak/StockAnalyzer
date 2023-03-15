import Foundation
import Combine


class NewsService {
    @Published var allNews: [News] = []
    let symbol: String?
    
    var newsSubscription: AnyCancellable?
    
    init(symbol: String? = nil) {
        self.symbol = symbol
        getNews()
    }
    
    func getNews() {
        var urlString = ""

        if let symbol = self.symbol {
            urlString = "https://stocknewsapi.com/api/v1?tickers=\(symbol)&items=10&page=1&token=\(ApiKeys.newsApi)"
            guard let url = URL(string: urlString) else {return}
            newsSubscription = NetworkingManager.download(url: url)
                .decode(type: NewsData.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedNews) in
                    self?.allNews = returnedNews.data
                    self?.newsSubscription?.cancel()
                })
        } else {
            urlString = "https://stocknewsapi.com/api/v1/category?section=general&items=20&page=1&token=\(ApiKeys.newsApi)"
            guard let url = URL(string: urlString) else {return}
            newsSubscription = NetworkingManager.download(url: url)
                .decode(type: NewsData.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedNews) in
                    self?.allNews = returnedNews.data
                    self?.newsSubscription?.cancel()
                })
        }
    }
}

