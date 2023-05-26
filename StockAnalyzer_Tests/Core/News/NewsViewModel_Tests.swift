import XCTest

@testable import StockAnalyzer

@MainActor
final class NewsViewModel_Tests: XCTestCase {
    func test_newsViewModel_fetchNews_SymbolIsEmpty() async throws {
        //Given
        let stockSymbol: String? = nil
        let vm = NewsViewModel(newsService: MockNewsService(stockSymbol: stockSymbol))
        
        //When
        await vm.fetchNews()
        
        //Then
        XCTAssertEqual(3, vm.news.count)
        XCTAssertFalse(vm.isLoading)
    }
    
    func test_newsViewModel_fetchNews_SymbolIsNotEmpty() async throws {
        //Given
        let stockSymbol: String? = "AMZN"
        let vm = NewsViewModel(newsService: MockNewsService(stockSymbol: stockSymbol))
        
        //When
        await vm.fetchNews()
        
        //Then
        XCTAssertEqual(2, vm.news.count)
        XCTAssertFalse(vm.isLoading)
    }
    
    func test_newsViewModel_sortNews() async throws {
        //Given
        let vm = NewsViewModel(newsService: MockNewsService(stockSymbol: nil))
        
        await vm.fetchNews()
        let sortedList: [News] = [
            News(title: "Google, Amazon, Meta, Microsoft, 15 others subject to EU content rules",
                 news_url: "https://www.reuters.com/technology/google-amazon-meta-microsoft-15-others-subject-eu-content-rules-2023-04-25/",
                 image_url: "https://cdn.snapi.dev/images/v1/l/f/nuqa3mnxevoenobla6da247rue-1852003.jpg",
                 date: "Tue, 25 Apr 2023 07:57:45 -0400",
                 source_name: "Reuters",
                 sentiment: "Negative", tickers: ["GOOGL", "META", "MSFT"]),
            News(title: "Machine learning algorithm sets Amazon stock price for May 2023",
                             news_url: "https://finbold.com/machine-learning-algorithm-sets-amazon-stock-price-for-may-2023/?SNAPI",
                             image_url: "https://cdn.snapi.dev/images/v1/m/a/machine-learning-algorithm-sets-amazon-stock-price-for-may-2023-1851763.jpg",
                             date: "Tue, 25 Apr 2023 06:00:00 -0400",
                             source_name: "Finbold",
                             sentiment: "Neutral", tickers: ["AMZN"]),
            News(title: "AI Boom: 2 Artificial Intelligence Stocks Billionaire Investors Are Buying Hand Over Fist",
                             news_url: "https://www.fool.com/investing/2023/04/25/ai-boom-ai-stocks-billionaire-investors-buying/",
                             image_url: "https://cdn.snapi.dev/images/v1/o/e/urlhttps3a2f2fgfoolcdncom2feditorial2fimages2f7288852fartificial-intelligencejpgopresizew400h400-1851500.jpg",
                             date: "Tue, 25 Apr 2023 06:00:00 -0400",
                             source_name: "The Motley Fool",
                             sentiment: "Positive", tickers: ["AMZN"])
        ]
        
        //Then
        XCTAssertEqual(vm.news, sortedList)
    }
}
