import XCTest

@testable import StockAnalyzer

final class FinanceService_Tests: XCTestCase {
    func test_FinanceService_fetchIncomeStatement() async throws {
        //Given
        let financeService = MockFinanceService()
        
        //When
        let result = await financeService.fetchIncomeStatement()
        
        //Then
        XCTAssertEqual(5, result.count)
    }
    
    func test_FinanceService_fetchBalanceSheet() async throws {
        //Given
        let financeService = MockFinanceService()
        
        //When
        let result = await financeService.fetchBalanceSheet()
        
        //Then
        XCTAssertEqual(5, result.count)
    }
    
    func test_FinanceService_fetchCashFlowStatement() async throws {
        //Given
        let financeService = MockFinanceService()
        
        //When
        let result = await financeService.fetchCashFlowStatement()
        
        //Then
        XCTAssertEqual(5, result.count)
    }
}
