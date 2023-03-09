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
            urlString = "https://mboum-finance.p.rapidapi.com/ne/news/?symbol=\(symbol)&rapidapi-key=9e32d01836msheb52c723f29c4c8p113a53jsn15c8b390588c"
            guard let url = URL(string: urlString) else {return}
            newsSubscription = NetworkingManager.download(url: url)
                .decode(type: CompanyNews.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedNews) in
                    self?.allNews = returnedNews.item
                    self?.newsSubscription?.cancel()
                })
        } else {
            urlString = "https://mboum-finance.p.rapidapi.com/ne/news?rapidapi-key=9e32d01836msheb52c723f29c4c8p113a53jsn15c8b390588c"
            guard let url = URL(string: urlString) else {return}
            newsSubscription = NetworkingManager.download(url: url)
                .decode(type: [News].self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedNews) in
                    self?.allNews = returnedNews
                    self?.newsSubscription?.cancel()
                })
        }
    }
}

