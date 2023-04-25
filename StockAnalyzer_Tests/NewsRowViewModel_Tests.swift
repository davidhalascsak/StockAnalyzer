import XCTest

@testable import StockAnalyzer

final class NewsRowViewModel_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_NewsRowViewModel_init() throws {
        //Given
        let news = News(title: "Spotify misses on both earnings and revenue", news_url: "", image_url: "", date: "Tue, 25 Apr 2023 07:57:45 -0400", source_name: "Bloomberg", sentiment: "Negative", tickers: ["Spotify"])
        
        // When
        let vm = NewsRowViewModel(news: news)
        
        //Then
        XCTAssertEqual(news, vm.news)
    }
    
    func test_NewsRowViewModel_createDate_ShouldReturnValidDate() {
        //Given
        let news = News(title: "Spotify misses on both earnings and revenue", news_url: "", image_url: "", date: "Tue, 25 Apr 2023 07:57:45 -0400", source_name: "Bloomberg", sentiment: "Negative", tickers: ["Spotify"])
        let vm = NewsRowViewModel(news: news)
        
        // When
        let date = vm.formatDate()
        
        //Then
        XCTAssertEqual("2023-04-25", date)
    }
    
    func test_NewsRowViewModel_createDate_ShouldReturnNotValidDate() {
        //Given
        let news = News(title: "Spotify misses on both earnings and revenue", news_url: "", image_url: "", date: "Tue, 25 Apr 2023 07:57:45 -0400", source_name: "Bloomberg", sentiment: "Negative", tickers: ["Spotify"])
        let vm = NewsRowViewModel(news: news)
        
        // When
        let date = vm.formatDate()
        
        //Then
        XCTAssertEqual("unknown date", date)
    }
}
