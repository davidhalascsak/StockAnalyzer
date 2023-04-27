import XCTest

@testable import StockAnalyzer

@MainActor
final class StockViewModel_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_StockViewModel_init() throws {
        //Given
        let symbol: String = "AAPL"
        
        //When
        let vm = StockViewModel(symbol: symbol, stockService: MockStockService(), sessionService: MockSessionService())
        
        //Then
        XCTAssertEqual(vm.symbol, symbol)
    }
    
    func test_StockViewModel_FetchData() async throws {
        //Given
        let symbol: String = "AAPL"
        let vm = StockViewModel(symbol: symbol, stockService: MockStockService(), sessionService: MockSessionService())
        
        //When
        await vm.fetchData()
        
        //Then
        XCTAssertNotNil(vm.companyProfile)
    }
}
