import XCTest

@testable import StockAnalyzer

@MainActor
final class PriceViewModel_Tests: XCTestCase {
    func test_PriceViewModel_FetchPrice() async throws {
        //Given
        let stockSymbol: String = "AAPL"
        let currency: String = "USD"
        let vm = PriceViewModel(stockSymbol: stockSymbol, currency: currency, stockService: MockStockService(stockSymbol: "AAPL"))
        
        //When
        await vm.fetchPrice()
        
        //Then
        XCTAssertEqual(vm.stockPrice?.price, 110)
    }
}
