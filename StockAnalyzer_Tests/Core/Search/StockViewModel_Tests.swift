import XCTest

@testable import StockAnalyzer

@MainActor
final class StockViewModel_Tests: XCTestCase {
    func test_StockViewModel_FetchData() async throws {
        //Given
        let stockSymbol: String = "AAPL"
        let authUser: TestAuthenticationUser? = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let vm = StockViewModel(stockSymbol: stockSymbol, stockService: MockStockService(stockSymbol: "AAPL"), sessionService: MockSessionService(currentUser: authUser))
        
        //When
        await vm.fetchData()
        
        //Then
        XCTAssertNotNil(vm.companyProfile)
    }
}
