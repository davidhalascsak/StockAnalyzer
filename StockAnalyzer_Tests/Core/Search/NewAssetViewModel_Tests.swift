import XCTest

@testable import StockAnalyzer

@MainActor
final class NewAssetViewModel_Tests: XCTestCase {
    func test_NewAssetViewModel_FetchPriceAtDate_dateValid() async throws {
        //Given
        let stockSymbol: String = "AAPL"
        let vm = NewAssetViewModel(stockSymbol: stockSymbol, portfolioService: MockPortfolioService(), stockService: MockStockService(stockSymbol: "AAPL"))
        
        //When
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: "2022-01-22")
        vm.buyDate = date ?? Date()
        await vm.fetchPrice()
        
        //Then
        XCTAssertEqual(vm.price, 110)
    }
    
    func test_NewAssetViewModel_FetchPriceAtDate_dateNotValid() async throws {
        //Given
        let stockSymbol: String = "AAPL"
        let vm = NewAssetViewModel(stockSymbol: stockSymbol, portfolioService: MockPortfolioService(), stockService: MockStockService(stockSymbol: "AAPL"))
        
        //When
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: "2022-01-21")
        vm.buyDate = date ?? Date()
        await vm.fetchPrice()
        
        //Then
        XCTAssertEqual(vm.price, 0)
    }
    
    func test_NewAssetViewModel_CalculateValue_PriceIsZero() async throws {
        //Given
        let stockSymbol: String = "AAPL"
        let vm = NewAssetViewModel(stockSymbol: stockSymbol, portfolioService: MockPortfolioService(), stockService: MockStockService(stockSymbol: "AAPL"))
        
        //When
        vm.calculateValue()
        
        //Then
        XCTAssertEqual(vm.value, "Invalid Value")
    }
    
    func test_NewAssetViewModel_CalculateValue_PriceIsNotZero() async throws {
        //Given
        let stockSymbol: String = "AAPL"
        let vm = NewAssetViewModel(stockSymbol: stockSymbol, portfolioService: MockPortfolioService(), stockService: MockStockService(stockSymbol: "AAPL"))
        
        //When
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: "2022-01-22")
        vm.buyDate = date ?? Date()
        await vm.fetchPrice()
        vm.calculateValue()
        
        //Then
        XCTAssertEqual(vm.value, "$110.00")
    }
    
    func test_NewAssetViewModel_CalculateValue_UnitIsMoreThanOne() async throws {
        //Given
        let stockSymbol: String = "AAPL"
        let vm = NewAssetViewModel(stockSymbol: stockSymbol, portfolioService: MockPortfolioService(), stockService: MockStockService(stockSymbol: "AAPL"))
        
        //When
        vm.units = 2.5
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: "2022-01-22")
        vm.buyDate = date ?? Date()
        await vm.fetchPrice()
        vm.calculateValue()
        
        //Then
        XCTAssertEqual(vm.value, "$275.00")
    }
    
    func test_NewAssetViewModel_AddPosition_ValueIsZero() async throws {
        //Given
        let stockSymbol: String = "AAPL"
        let vm = NewAssetViewModel(stockSymbol: stockSymbol, portfolioService: MockPortfolioService(), stockService: MockStockService(stockSymbol: "AAPL"))
        
        //When
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: "2022-01-22")
        vm.buyDate = date ?? Date()
        await vm.addPositionToPortfolio()
        
        //Then
        XCTAssertTrue(vm.showAlert)
        XCTAssertEqual(vm.alertTitle, "Error")
        XCTAssertEqual(vm.alertText, "The price is invalid.")
    }
    
    func test_NewAssetViewModel_AddPosition_ValueIsNotZero() async throws {
        //Given
        let stockSymbol: String = "AAPL"
        let vm = NewAssetViewModel(stockSymbol: stockSymbol, portfolioService: MockPortfolioService(), stockService: MockStockService(stockSymbol: "AAPL"))
        
        //When
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: "2022-01-22")
        vm.buyDate = date ?? Date()
        await vm.fetchPrice()
        await vm.addPositionToPortfolio()
        
        //Then
        XCTAssertFalse(vm.showAlert)
        XCTAssertEqual(vm.alertTitle, "")
        XCTAssertEqual(vm.alertText, "")
    }
}
