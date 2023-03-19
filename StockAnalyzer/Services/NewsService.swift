import Foundation
import Combine


class NewsService {
    @Published var allNews: [News] = []
    
    let symbol: String?
    var cancellables = Set<AnyCancellable>()
    
    init(symbol: String?) {
        self.symbol = symbol
        fetchData()
    }
    
    func fetchData() {
        var url = ""
        
        if let symbol = self.symbol {
            url = "https://stocknewsapi.com/api/v1?tickers=\(symbol)&items=10&page=1&token=\(ApiKeys.newsApi)"
        } else {
            url = "https://stocknewsapi.com/api/v1/category?section=general&items=20&page=1&token=\(ApiKeys.newsApi)"
        }
        
        guard let url = URL(string: url) else {return}
        
        NetworkingManager.download(url: url)
            .decode(type: NewsData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedNews) in
                self?.allNews = returnedNews.data
            })
            .store(in: &cancellables)
    }
}

