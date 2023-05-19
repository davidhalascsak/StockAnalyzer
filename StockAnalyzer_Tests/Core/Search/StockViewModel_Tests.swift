import XCTest

@testable import StockAnalyzer

@MainActor
final class StockViewModel_Tests: XCTestCase {
    func test_StockViewModel_FetchData() async throws {
        //Given
        let symbol: String = "AAPL"
        let authUser: TestAuthenticationUser? = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let vm = StockViewModel(symbol: symbol, stockService: MockStockService(), sessionService: MockSessionService(currentUser: authUser))
        
        //When
        await vm.fetchData()
        
        //Then
        XCTAssertNotNil(vm.companyProfile)
    }
}
