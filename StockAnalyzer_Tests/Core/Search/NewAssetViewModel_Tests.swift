import XCTest

@testable import StockAnalyzer

@MainActor
final class NewAssetViewModel_Tests: XCTestCase {
    func test_NewAssetViewModel_FetchPriceAtDate() async throws {
        //Given
        let stockSymbol: String = "AAPL"
        let vm = NewAssetViewModel(stockSymbol: stockSymbol, portfolioService: MockPortfolioService(), stockService: MockStockService())
        
        //When
        await vm.fetchPrice()
        
        //Then
        XCTAssertEqual(vm.price, 110)
    }
    
    func test_NewAssetViewModel_CalculateValue_PriceIsZero() async throws {
        //Given
        let stockSymbol: String = "AAPL"
        let vm = NewAssetViewModel(stockSymbol: stockSymbol, portfolioService: MockPortfolioService(), stockService: MockStockService())
        
        //When
        vm.calculateValue()
        
        //Then
        XCTAssertEqual(vm.value, "Invalid Value")
    }
    
    func test_NewAssetViewModel_CalculateValue_PriceIsNotZero() async throws {
        //Given
        let stockSymbol: String = "AAPL"
        let vm = NewAssetViewModel(stockSymbol: stockSymbol, portfolioService: MockPortfolioService(), stockService: MockStockService())
        
        //When
        await vm.fetchPrice()
        vm.calculateValue()
        
        //Then
        XCTAssertEqual(vm.value, "$110.00")
    }
    
    func test_NewAssetViewModel_CalculateValue_UnitIsMoreThanOne() async throws {
        //Given
        let stockSymbol: String = "AAPL"
        let vm = NewAssetViewModel(stockSymbol: stockSymbol, portfolioService: MockPortfolioService(), stockService: MockStockService())
        
        //When
        vm.units = 2.5
        await vm.fetchPrice()
        vm.calculateValue()
        
        //Then
        XCTAssertEqual(vm.value, "$275.00")
    }
    
    func test_NewAssetViewModel_AddPosition_ValueIsZero() async throws {
        //Given
        let stockSymbol: String = "AAPL"
        let vm = NewAssetViewModel(stockSymbol: stockSymbol, portfolioService: MockPortfolioService(), stockService: MockStockService())
        
        //When
        await vm.addPositionToPortfolio()
        
        //Then
        XCTAssertTrue(vm.showAlert)
        XCTAssertEqual(vm.alertTitle, "Error")
        XCTAssertEqual(vm.alertText, "The price is invalid.")
    }
    
    func test_NewAssetViewModel_AddPosition_ValueIsNotZero() async throws {
        //Given
        let stockSymbol: String = "AAPL"
        let vm = NewAssetViewModel(stockSymbol: stockSymbol, portfolioService: MockPortfolioService(), stockService: MockStockService())
        
        //When
        await vm.fetchPrice()
        await vm.addPositionToPortfolio()
        
        //Then
        XCTAssertFalse(vm.showAlert)
        XCTAssertEqual(vm.alertTitle, "")
        XCTAssertEqual(vm.alertText, "")
    }
}
