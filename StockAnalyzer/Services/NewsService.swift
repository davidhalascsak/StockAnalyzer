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

class MockNewsService: NewsServiceProtocol {
    let news: [News]
    let symbol: String?
    
    init(symbol: String?) {
        self.symbol = symbol
        
        let news1 = News(title: "Google, Amazon, Meta, Microsoft, 15 others subject to EU content rules",
                         news_url: "https://www.reuters.com/technology/google-amazon-meta-microsoft-15-others-subject-eu-content-rules-2023-04-25/",
                         image_url: "https://cdn.snapi.dev/images/v1/l/f/nuqa3mnxevoenobla6da247rue-1852003.jpg",
                         date: "Tue, 25 Apr 2023 07:57:45 -0400",
                         source_name: "Reuters",
                         sentiment: "Negative", tickers: ["Google", "Meta", "Microsoft"])
        
        let news2 = News(title: "Machine learning algorithm sets Amazon stock price for May 2023",
                         news_url: "https://finbold.com/machine-learning-algorithm-sets-amazon-stock-price-for-may-2023/?SNAPI",
                         image_url: "https://cdn.snapi.dev/images/v1/m/a/machine-learning-algorithm-sets-amazon-stock-price-for-may-2023-1851763.jpg",
                         date: "Tue, 25 Apr 2023 06:00:00 -0400",
                         source_name: "Finbold",
                         sentiment: "Neutral", tickers: ["Amazon"])
        
        let news3 = News(title: "AI Boom: 2 Artificial Intelligence Stocks Billionaire Investors Are Buying Hand Over Fist",
                         news_url: "https://www.fool.com/investing/2023/04/25/ai-boom-ai-stocks-billionaire-investors-buying/",
                         image_url: "https://cdn.snapi.dev/images/v1/o/e/urlhttps3a2f2fgfoolcdncom2feditorial2fimages2f7288852fartificial-intelligencejpgopresizew400h400-1851500.jpg",
                         date: "Tue, 25 Apr 2023 06:00:00 -0400",
                         source_name: "The Motley Fool",
                         sentiment: "Positive", tickers: ["Amazon"])
        
        self.news = [news1, news2, news3]
    }
    
    func fetchData() async -> [News] {
        if let symbol = symbol {
            return self.news.filter({$0.tickers.contains(symbol)})
        }
        return self.news
    }
}

protocol NewsServiceProtocol {
    func fetchData() async -> [News]
}
