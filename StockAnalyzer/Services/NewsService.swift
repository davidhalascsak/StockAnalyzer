import Foundation

class NewsService: NewsServiceProtocol {
    let stockSymbol: String?
    
    init(stockSymbol: String?) {
        self.stockSymbol = stockSymbol
    }
    
    func fetchNews() async -> [News]  {
        var url = ""
        if let stockSymbol = stockSymbol {
            url = "https://stocknewsapi.com/api/v1?tickers=\(stockSymbol)&items=10&page=1&token=\(ApiKeys.newsApi)"
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
            return []
        } catch {
            return []
        }
    }
}

class MockNewsService: NewsServiceProtocol {
    let db: MockDatabase = MockDatabase()
    let stockSymbol: String?
    
    init(stockSymbol: String?) {
        self.stockSymbol = stockSymbol
    }
    
    func fetchNews() async -> [News] {
        if let symbol = stockSymbol {
            return db.news.filter({$0.tickers?.contains(symbol) ?? false})
        }
        return db.news
    }
}

protocol NewsServiceProtocol {
    func fetchNews() async -> [News]
}
