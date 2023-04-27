import XCTest

@testable import StockAnalyzer

@MainActor
final class PriceViewModel_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_PriceViewModel_init() throws {
        //Given
        let symbol: String = "AAPL"
        let currency: String = "USD"
        
        //When
        let vm = PriceViewModel(symbol: symbol, currency: currency, stockService: MockStockService())
        
        //Then
        XCTAssertEqual(vm.symbol, symbol)
        XCTAssertEqual(vm.currency, currency)
    }
    
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
