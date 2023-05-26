import XCTest

@testable import StockAnalyzer

@MainActor
final class PortfolioRowViewModel_Tests: XCTestCase {
    func testPortfolioRowViewModel_calculateCurrentValue() async throws {
        //Given
        var asset = Asset(stockSymbol: "AAPL", units: 2.0, averagePrice: 132.5, positionCount: 2)
        let position1 = Position(date: "2023-02-02", units: 1, price: 132.5)
        let position2 = Position(date: "2023-01-02", units: 1, price: 132.5)
        asset.positions = [position1, position2]
        
        let vm = PortfolioRowViewModel(asset: asset, stockService: MockStockService())
        
        //When
        await vm.calculateCurrentValue()
        let currentValue = (110 / 132.5) * 265.0
        
        //Then
        XCTAssertEqual(vm.currentValue, currentValue)
        XCTAssertFalse(vm.isLoading)
    }
    
    func test_PortfolioRowViewModel_FormatValue_ValueIsNegative() throws {
        //Given
        
        //When
        let number = -20000.00
        let formatedValue: String = number.formattedPrice
        
        //then
        XCTAssertEqual("-$20000", formatedValue)
        
    }
    
    func test_PortfolioRowViewModel_FormatValue_ValueIsPositive() throws {
        //Given
        
        //When
        let number = 20000.00
        let formatedValue: String = number.formattedPrice
        
        //then
        XCTAssertEqual("$20000", formatedValue)
        
    }
}
