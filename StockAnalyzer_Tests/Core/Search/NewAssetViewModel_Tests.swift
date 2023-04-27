import XCTest

@testable import StockAnalyzer

@MainActor
final class NewAssetViewModel_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_NewAssetViewModel_init() throws {
        //Given
        let symbol: String = "AAPL"
        
        //When
        let vm = NewAssetViewModel(symbol: symbol, portfolioService: MockPortfolioService(), stockService: MockStockService())
        
        //Then
        XCTAssertEqual(vm.symbol, symbol)
    }
    
    func test_NewAssetViewModel_FetchPriceAtDate() async throws {
        //Given
        let symbol: String = "AAPL"
        let vm = NewAssetViewModel(symbol: symbol, portfolioService: MockPortfolioService(), stockService: MockStockService())
        
        //When
        await vm.fetchPrice()
        
        //Then
        XCTAssertEqual(vm.price, 100)
    }
    
    func test_NewAssetViewModel_CalculateValue_PriceIsZero() async throws {
        //Given
        let symbol: String = "AAPL"
        let vm = NewAssetViewModel(symbol: symbol, portfolioService: MockPortfolioService(), stockService: MockStockService())
        
        //When
        vm.calculateValue()
        
        //Then
        XCTAssertEqual(vm.value, "$0.00")
    }
    
    func test_NewAssetViewModel_CalculateValue_PriceIsNotZero() async throws {
        //Given
        let symbol: String = "AAPL"
        let vm = NewAssetViewModel(symbol: symbol, portfolioService: MockPortfolioService(), stockService: MockStockService())
        
        //When
        await vm.fetchPrice()
        vm.calculateValue()
        
        //Then
        XCTAssertEqual(vm.value, "$100.00")
    }
    
    func test_NewAssetViewModel_CalculateValue_UnitIsMoreThanOne() async throws {
        //Given
        let symbol: String = "AAPL"
        let vm = NewAssetViewModel(symbol: symbol, portfolioService: MockPortfolioService(), stockService: MockStockService())
        
        //When
        vm.units = 2.5
        await vm.fetchPrice()
        vm.calculateValue()
        
        //Then
        XCTAssertEqual(vm.value, "$250.00")
    }
    
    func test_NewAssetViewModel_AddPosition_ValueIsZero() async throws {
        //Given
        let symbol: String = "AAPL"
        let vm = NewAssetViewModel(symbol: symbol, portfolioService: MockPortfolioService(), stockService: MockStockService())
        
        //When
        await vm.addPositionToPortfolio()
        
        //Then
        XCTAssertTrue(vm.showAlert)
        XCTAssertEqual(vm.alertTitle, "Error")
        XCTAssertEqual(vm.alertText, "The price cannot be 0.")
    }
    
    func test_NewAssetViewModel_AddPosition_ValueIsNotZero() async throws {
        //Given
        let symbol: String = "AAPL"
        let vm = NewAssetViewModel(symbol: symbol, portfolioService: MockPortfolioService(), stockService: MockStockService())
        
        //When
        await vm.fetchPrice()
        await vm.addPositionToPortfolio()
        
        //Then
        XCTAssertFalse(vm.showAlert)
        XCTAssertEqual(vm.alertTitle, "")
        XCTAssertEqual(vm.alertText, "")
    }
}
