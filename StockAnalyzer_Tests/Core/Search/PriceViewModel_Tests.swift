import XCTest

@testable import StockAnalyzer

@MainActor
final class PriceViewModel_Tests: XCTestCase {
    func test_PriceViewModel_FetchPrice() async throws {
        //Given
        let symbol: String = "AAPL"
        let currency: String = "USD"
        let vm = PriceViewModel(symbol: symbol, currency: currency, stockService: MockStockService())
        
        //When
        await vm.fetchData()
        
        //Then
        XCTAssertEqual(vm.stockPrice?.price, 110)
    }
}
