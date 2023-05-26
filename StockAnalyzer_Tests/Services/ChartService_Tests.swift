import XCTest

@testable import StockAnalyzer

final class ChartService_Tests: XCTestCase {

    func test_ChartService_get5Min() async throws {
        //Given
        let chartService = MockChartService(stockSymbol: "AAPL")
        
        //When
        let result = await chartService.get5Min()
        
        //Then
        XCTAssertEqual(14, result.count)
    }
    
    func test_ChartService_getHourly() async throws {
        //Given
        let chartService = MockChartService(stockSymbol: "AAPL")
        
        //When
        let result = await chartService.getHourly()
        
        //Then
        XCTAssertEqual(14, result.count)
    }
    
    func test_ChartService_Daily() async throws {
        //Given
        let chartService = MockChartService(stockSymbol: "AAPL")
        
        //When
        let result = await chartService.getDaily()
        
        //Then
        XCTAssertEqual(15, result.count)
    }
}
