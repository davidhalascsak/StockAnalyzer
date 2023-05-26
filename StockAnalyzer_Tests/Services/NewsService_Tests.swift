import XCTest

@testable import StockAnalyzer

@MainActor
final class NewsService_Test: XCTestCase {
    func test_NewsService_fetchNews_SymbolIsNil() async throws {
        //Given
        let newsService = MockNewsService(stockSymbol: nil)
        
        //When
        let news = await newsService.fetchNews()
        
        //Then
        XCTAssertEqual(3, news.count)
    }
    
    func test_NewsService_fetchNews_SymbolIsNotNil() async throws {
        //Given
        let newsService = MockNewsService(stockSymbol: "AMZN")
        
        //When
        let news = await newsService.fetchNews()
        
        //Then
        XCTAssertEqual(2, news.count)
    }
}
