import XCTest

@testable import StockAnalyzer

final class FinanceService_Tests: XCTestCase {
    func test_FinanceService_fetchIncomeStatement_dataFound() async throws {
        //Given
        let financeService = MockFinanceService(stockSymbol: "AAPL")
        
        //When
        let result = await financeService.fetchIncomeStatement()
        
        //Then
        XCTAssertEqual(5, result.count)
    }
    
    func test_FinanceService_fetchIncomeStatement_dataNotFound() async throws {
        //Given
        let financeService = MockFinanceService(stockSymbol: "AMZN")
        
        //When
        let result = await financeService.fetchIncomeStatement()
        
        //Then
        XCTAssertEqual(0, result.count)
    }
    
    func test_FinanceService_fetchBalanceSheet_dataFound() async throws {
        //Given
        let financeService = MockFinanceService(stockSymbol: "AAPL")
        
        //When
        let result = await financeService.fetchBalanceSheet()
        
        //Then
        XCTAssertEqual(5, result.count)
    }
    
    func test_FinanceService_fetchBalanceSheet_dataNotFound() async throws {
        //Given
        let financeService = MockFinanceService(stockSymbol: "AMZN")
        
        //When
        let result = await financeService.fetchBalanceSheet()
        
        //Then
        XCTAssertEqual(0, result.count)
    }
    
    func test_FinanceService_fetchCashFlowStatement_dataFound() async throws {
        //Given
        let financeService = MockFinanceService(stockSymbol: "AAPL")
        
        //When
        let result = await financeService.fetchCashFlowStatement()
        
        //Then
        XCTAssertEqual(5, result.count)
    }
    
    func test_FinanceService_fetchCashFlowStatement_dataNotFound() async throws {
        //Given
        let financeService = MockFinanceService(stockSymbol: "AMZN")
        
        //When
        let result = await financeService.fetchCashFlowStatement()
        
        //Then
        XCTAssertEqual(0, result.count)
    }
}
