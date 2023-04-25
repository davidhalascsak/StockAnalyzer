import XCTest

@testable import StockAnalyzer

@MainActor
final class NewsViewModel_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_newsViewModel_fetchNews_SymbolIsEmpty() async throws {
        //Given
        let symbol: String? = nil
        let vm = NewsViewModel(newsService: MockNewsService(symbol: symbol))
        
        //When
        await vm.fetchNews()
        
        //Then
        XCTAssertEqual(3, vm.news.count)
        XCTAssertFalse(vm.isLoading)
    }
    
    func test_newsViewModel_fetchNews_SymbolIsNotEmpty() async throws {
        //Given
        let symbol: String? = "Amazon"
        let vm = NewsViewModel(newsService: MockNewsService(symbol: symbol))
        
        //When
        await vm.fetchNews()
        
        //Then
        XCTAssertEqual(2, vm.news.count)
        XCTAssertFalse(vm.isLoading)
    }
    
    func test_newsViewModel_sortNews() async throws {
        //Given
        let symbol: String? = nil
        let vm = NewsViewModel(newsService: NewsService(symbol: symbol))
        let news1 = News(title: "Google, Amazon, Meta, Microsoft, 15 others subject to EU content rules",
                         news_url: "https://www.reuters.com/technology/google-amazon-meta-microsoft-15-others-subject-eu-content-rules-2023-04-25/",
                         image_url: "https://cdn.snapi.dev/images/v1/l/f/nuqa3mnxevoenobla6da247rue-1852003.jpg",
                         date: "Tue, 25 Apr 2023 07:57:45 -0400",
                         source_name: "Reuters",
                         sentiment: "Negative", tickers: ["Google", "Amazon", "Meta", "Microsoft"])
        
        let news2 = News(title: "Machine learning algorithm sets Amazon stock price for May 2023",
                         news_url: "https://finbold.com/machine-learning-algorithm-sets-amazon-stock-price-for-may-2023/?SNAPI",
                         image_url: "https://cdn.snapi.dev/images/v1/m/a/machine-learning-algorithm-sets-amazon-stock-price-for-may-2023-1851763.jpg",
                         date: "Tue, 25 Apr 2023 06:00:00 -0400",
                         source_name: "Finbold",
                         sentiment: "Neutral", tickers: ["Amazon", "Adobe"])
        
        vm.news = [news2, news1]
        let sortedList: [News] = [news1, news2]
        
        //When
        vm.sortNews()
        
        //Then
        XCTAssertEqual(vm.news, sortedList)
    }
}
