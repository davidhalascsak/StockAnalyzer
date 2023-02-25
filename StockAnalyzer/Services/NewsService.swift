import Foundation
import Combine


class NewsService {
    @Published var allNews: [News] = []
    
    var newsSubscription: AnyCancellable?
    
    init() {
        getNews()
    }
    
    func getNews() {
        // https://mboum-finance.p.rapidapi.com/ne/news/?symbol=TSLA&rapidapi-key=9e32d01836msheb52c723f29c4c8p113a53jsn15c8b390588c
        guard let url = URL(string:  "https://mboum-finance.p.rapidapi.com/ne/news?rapidapi-key=9e32d01836msheb52c723f29c4c8p113a53jsn15c8b390588c")
        else {return}
                
        newsSubscription = NetworkingManager.download(url: url)
            .decode(type: [News].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedNews) in
                self?.allNews = returnedNews
                self?.newsSubscription?.cancel()
            })
    }
}
