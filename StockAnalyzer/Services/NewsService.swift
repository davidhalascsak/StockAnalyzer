import Foundation

class NewsService: NewsServiceProtocol {
    let symbol: String?
    
    init(symbol: String?) {
        self.symbol = symbol
    }
    
    func fetchData() async -> [News]  {
        var url = ""
        if let symbol = self.symbol {
            url = "https://stocknewsapi.com/api/v1?tickers=\(symbol)&items=10&page=1&token=\(ApiKeys.newsApi)"
        } else {
            url = "https://stocknewsapi.com/api/v1/category?section=general&items=20&page=1&token=\(ApiKeys.newsApi)"
        }
        
        guard let url = URL(string: url) else {return []}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let newsData = try? decoder.decode(NewsData.self, from: data)
            if let newsData = newsData {
                return newsData.data
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return []
    }
}


protocol NewsServiceProtocol {
    func fetchData() async -> [News]
}

