import XCTest

@testable import StockAnalyzer

@MainActor
final class PositionRowViewModel_Tests: XCTestCase {
    func test_PositionRowViewModel_CalculateCurrentValue() async throws {
        //Given
        let position = Position(id: UUID().uuidString, symbol: "AAPL", date: "2023-02-02", units: 1, price: 132.5, investedAmount: 132.5)
        let vm = PositionRowViewModel(position: position, stockService: MockStockService())
        
        //When
        let currentValue: Double = (110 / 132.5) * 132.5
        await vm.calculateCurrentValue()
        
        //Then
        XCTAssertEqual(vm.currentValue, currentValue)
        XCTAssertFalse(vm.isLoading)
    }
    
    func test_PositionRowViewModel_FormatValue_ValueIsNegative() throws {
        //Given
        let position = Position(id: UUID().uuidString, symbol: "AAPL", date: "2023-02-02", units: 1, price: 132.5, investedAmount: 132.5)
        let vm = PositionRowViewModel(position: position, stockService: MockStockService())
        
        //When
        let formatedValue: String = vm.formatValue(value: -20000)
        
        //then
        XCTAssertEqual("-$20000.00", formatedValue)
        
    }
    
    func test_PositionRowViewModel_FormatValue_ValueIsPositive() throws {
        //Given
        let position = Position(id: UUID().uuidString, symbol: "AAPL", date: "2023-02-02", units: 1, price: 132.5, investedAmount: 132.5)
        let vm = PositionRowViewModel(position: position, stockService: MockStockService())
        
        //When
        let formatedValue: String = vm.formatValue(value: 20000)
        
        //then
        XCTAssertEqual("$20000.00", formatedValue)
        
    }
}
