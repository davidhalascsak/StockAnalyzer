import XCTest

@testable import StockAnalyzer

final class SearchService_Test: XCTestCase {
    
    func test_SearchService_fetchData_EmptyString() async throws {
        //Given
        let searchService = MockSearchService()
        
        //When
        let result = await searchService.fetchData(text: "")
        
        //Then
        XCTAssertEqual(0, result.count)
    }
    
    func test_SearchService_fetchData_searchByTicker() async throws {
        //Given
        let searchService = MockSearchService()
        
        //When
        let result = await searchService.fetchData(text: "AAPL")
        
        //Then
        XCTAssertEqual(1, result.count)
    }
    
    func test_SearchService_fetchData_searchByName() async throws {
        //Given
        let searchService = MockSearchService()
        
        //When
        let result = await searchService.fetchData(text: "Apple")
        
        //Then
        XCTAssertEqual(1, result.count)
    }
    
    func test_SearchService_fetchData_noMatchFound() async throws {
        //Given
        let searchService = MockSearchService()
        
        //When
        let result = await searchService.fetchData(text: "Mol")
        
        //Then
        XCTAssertEqual(0, result.count)
    }
}
