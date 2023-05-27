import XCTest

@testable import StockAnalyzer

final class ChartService_Tests: XCTestCase {

    func test_ChartService_get5Min_dataFound() async throws {
        //Given
        let chartService = MockChartService(stockSymbol: "AAPL")
        
        //When
        let result = await chartService.get5Min()
        
        //Then
        XCTAssertEqual(14, result.count)
    }
    
    func test_ChartService_get5Min_dataNotFound() async throws {
        //Given
        let chartService = MockChartService(stockSymbol: "AMZN")
        
        //When
        let result = await chartService.get5Min()
        
        //Then
        XCTAssertEqual(0, result.count)
    }
    
    func test_ChartService_getHourly_dataFound() async throws {
        //Given
        let chartService = MockChartService(stockSymbol: "AAPL")
        
        //When
        let result = await chartService.getHourly()
        
        //Then
        XCTAssertEqual(14, result.count)
    }
    
    func test_ChartService_getHourly_dataNotFound() async throws {
        //Given
        let chartService = MockChartService(stockSymbol: "AMZN")
        
        //When
        let result = await chartService.getHourly()
        
        //Then
        XCTAssertEqual(0, result.count)
    }
    
    func test_ChartService_Daily_dataFound() async throws {
        //Given
        let chartService = MockChartService(stockSymbol: "AAPL")
        
        //When
        let result = await chartService.getDaily()
        
        //Then
        XCTAssertEqual(15, result.count)
    }
    
    func test_ChartService_getDaily_dataNotFound() async throws {
        //Given
        let chartService = MockChartService(stockSymbol: "AMZN")
        
        //When
        let result = await chartService.getHourly()
        
        //Then
        XCTAssertEqual(0, result.count)
    }
}
