import XCTest

@testable import StockAnalyzer

@MainActor
final class PortfolioRowViewModel_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPortfolioRowViewModel_init() throws {
        //Given
        let asset = Asset(symbol: "AAPL", units: 2.0, averagePrice: 132.5, investedAmount: 265.0, positionCount: 1)
        
        //When
        let vm = PortfolioRowViewModel(asset: asset, stockService: MockStockService())
        
        //Then
        XCTAssertEqual(vm.asset.symbol, asset.symbol)
        XCTAssertEqual(vm.asset.units, asset.units)
        XCTAssertEqual(vm.asset.averagePrice, asset.averagePrice)
        XCTAssertEqual(vm.asset.investedAmount, asset.investedAmount)
        XCTAssertEqual(vm.asset.positionCount, asset.positionCount)
    }
    
    func testPortfolioRowViewModel_calculateCurrentValue() async throws {
        //Given
        var asset = Asset(symbol: "AAPL", units: 2.0, averagePrice: 132.5, investedAmount: 265.0, positionCount: 2)
        let position1 = Position(symbol: "AAPL", date: "2023-02-02", units: 1, price: 132.5, investedAmount: 132.5)
        let position2 = Position(symbol: "AAPL", date: "2023-01-02", units: 1, price: 132.5, investedAmount: 132.5)
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
        let asset = Asset(symbol: "AAPL", units: 2.0, averagePrice: 132.5, investedAmount: 265.0, positionCount: 2)
        let vm = PortfolioRowViewModel(asset: asset, stockService: MockStockService())
        
        //When
        let formatedValue: String = vm.formatValue(value: -20000)
        
        //then
        XCTAssertEqual("-$20000.00", formatedValue)
        
    }
    
    func test_PortfolioRowViewModel_FormatValue_ValueIsPositive() throws {
        //Given
        let asset = Asset(symbol: "AAPL", units: 2.0, averagePrice: 132.5, investedAmount: 265.0, positionCount: 2)
        let vm = PortfolioRowViewModel(asset: asset, stockService: MockStockService())
        
        //When
        let formatedValue: String = vm.formatValue(value: 20000)
        
        //then
        XCTAssertEqual("$20000.00", formatedValue)
        
    }
}
