import XCTest

@testable import StockAnalyzer

final class NewsRowViewModel_Tests: XCTestCase {
    func test_NewsRowViewModel_createDate_ShouldReturnValidDate() {
        //Given
        let news = News(title: "Spotify misses on both earnings and revenue", news_url: "", image_url: "", date: "Tue, 25 Apr 2023 07:57:45 -0400", source_name: "Bloomberg", sentiment: "Negative", tickers: ["Spotify"])
        
        // When
        let date = news.date.formatDateString(from: "E, d MMM y HH:mm:ss z", to: "yyyy-MM-dd")
        
        //Then
        XCTAssertEqual("2023-04-25", date)
    }
    
    func test_NewsRowViewModel_createDate_ShouldReturnNotValidDate() {
        //Given
        let news = News(title: "Spotify misses on both earnings and revenue", news_url: "", image_url: "", date: "25 Apr 2023", source_name: "Bloomberg", sentiment: "Negative", tickers: ["Spotify"])
        
        // When
        let date = news.date.formatDateString(from: "E, d MMM y HH:mm:ss z", to: "yyyy-MM-dd")
        
        
        //Then
        XCTAssertEqual("unknown date", date)
    }
}
