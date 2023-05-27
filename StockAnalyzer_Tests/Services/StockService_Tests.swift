import XCTest

@testable import StockAnalyzer

final class StockService: XCTestCase {
    func test_StockService_fetchProfile_profileFound() async throws {
        //Given
        let stockService = MockStockService(stockSymbol: "AAPL")
        
        //When
        let company = await stockService.fetchProfile()
        
        //Then
        XCTAssertNotNil(company)
    }
    
    func test_StockService_fetchProfile_profileNotFound() async throws {
        //Given
        let stockService = MockStockService(stockSymbol: "AMZN")
        
        //When
        let company = await stockService.fetchProfile()
        
        //Then
        XCTAssertNil(company)
    }
    
    func test_StockService_fetchPriceInRealTime_dataFound() async throws {
        //Given
        let stockService = MockStockService(stockSymbol: "AAPL")
        
        //When
        let price = await stockService.fetchPriceInRealTime()
        
        //Then
        XCTAssertNotNil(price)
    }
    
    func test_StockService_fetchPriceInRealTime_dataNotFound() async throws {
        //Given
        let stockService = MockStockService(stockSymbol: "AMZN")
        
        //When
        let price = await stockService.fetchPriceInRealTime()
        
        //Then
        XCTAssertNil(price)
    }
    
    func test_StockService_fetchPriceAtDate_dateCorrent() async throws {
        //Given
        let stockService = MockStockService(stockSymbol: "AAPL")
        
        //When
        let price = await stockService.fetchPriceAtDate(date: "2022-01-22")
        
        //Then
        XCTAssertEqual(110.0, price)
        
    }
    
    func test_StockService_fetchPriceAtDate_dateNotCorrent() async throws {
        //Given
        let stockService = MockStockService(stockSymbol: "AAPL")
        
        //When
        let price = await stockService.fetchPriceAtDate(date: "2022-01-23")
        
        //Then
        XCTAssertEqual(0.0, price)
    }
    
    func test_StockService_fetchMarketCap_dataFound() async throws {
        //Given
        let stockService = MockStockService(stockSymbol: "AAPL")
        
        //When
        let marketCap = await stockService.fetchMarketCap()
        
        //Then
        XCTAssertEqual(10000000, marketCap)
    }
    
    func test_StockService_fetchMarketCap_dataNotFound() async throws {
        //Given
        let stockService = MockStockService(stockSymbol: "AMZN")
        
        //When
        let marketCap = await stockService.fetchMarketCap()
        
        //Then
        XCTAssertEqual(0, marketCap)
    }
    
    func test_StockService_fetchRatios_dataFound() async throws {
        //Given
        let stockService = MockStockService(stockSymbol: "AAPL")
        
        //When
        let ratios = await stockService.fetchRatios()
        
        //Then
        XCTAssertNotNil(ratios)
    }
    
    func test_StockService_fetchRatios_dataNotFound() async throws {
        //Given
        let stockService = MockStockService(stockSymbol: "AMZN")
        
        //When
        let ratios = await stockService.fetchRatios()
        
        //Then
        XCTAssertNil(ratios)
    }
    
    func test_StockService_fetchGrowthRates_dataFound() async throws {
        //Given
        let stockService = MockStockService(stockSymbol: "AAPL")
        
        //When
        let growthRates = await stockService.fetchGrowthRates()
        
        //Then
        XCTAssertNotNil(growthRates)
    }
    
    func test_StockService_fetchGrowthRates_dataNotFound() async throws {
        //Given
        let stockService = MockStockService(stockSymbol: "AMZN")
        
        //When
        let growthRates = await stockService.fetchGrowthRates()
        
        //Then
        XCTAssertNil(growthRates)
    }
    
    func test_StockService_fetchMetrics_dataFound() async throws {
        //Given
        let stockService = MockStockService(stockSymbol: "AAPL")
        
        //When
        let metrics = await stockService.fetchMetrics()
        
        //Then
        XCTAssertNotNil(metrics)
    }
    
    func test_StockService_fetchMetrics_dataNotFound() async throws {
        //Given
        let stockService = MockStockService(stockSymbol: "AMZN")
        
        //When
        let metrics = await stockService.fetchMetrics()
        
        //Then
        XCTAssertNil(metrics)
    }
}
