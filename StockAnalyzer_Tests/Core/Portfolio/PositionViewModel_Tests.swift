import XCTest

@testable import StockAnalyzer

@MainActor
final class PositionViewModel_Tests: XCTestCase {
    func test_PositionViewModel_fetchData() async throws {
        //Given
        let asset = Asset(stockSymbol: "AAPL", units: 2.0, averagePrice: 132.5, positionCount: 2)
        let vm = PositionViewModel(asset: asset, stockService: MockStockService(stockSymbol: "AAPL"), portfolioService: MockPortfolioService(), imageService: MockImageService())
        
        //When
        await vm.fetchData()
        
        //Then
        XCTAssertNotNil(vm.companyProfile)
        XCTAssertNotNil(vm.price)
        XCTAssertFalse(vm.isLoading)
    }

    
    func test_PositionViewModel_changeInPrice() async throws {
        //Given
        let asset = Asset(stockSymbol: "AAPL", units: 2.0, averagePrice: 132.5, positionCount: 2)
        let vm = PositionViewModel(asset: asset, stockService: MockStockService(stockSymbol: "AAPL"), portfolioService: MockPortfolioService(), imageService: MockImageService())
        
        //When
        await vm.fetchData()
        let change: String = "\(String(format: "%.2f" ,vm.price?.change ?? 0.0))(\(String(format: "%.2f" ,vm.price?.changeInPercentage ?? 0.0))%)"
        
        //Then
        XCTAssertEqual(change, "10.00(10.00%)")
    }
    
    func test_PositionViewModel_deletePosition() async throws {
        //Given
        var asset = Asset(stockSymbol: "AAPL", units: 2.0, averagePrice: 132.5, positionCount: 2)
        let position1 = Position(id: "1", date: "2023-02-02", units: 1, price: 132.5)
        let position2 = Position(id: "2", date: "2023-01-02", units: 1, price: 132.5)
        asset.positions = [position1, position2]
        
        let vm = PositionViewModel(asset: asset, stockService: MockStockService(stockSymbol: "AAPL"), portfolioService: MockPortfolioService(), imageService: MockImageService())
        
        //When
        let position = vm.asset.positions?[1]
        await vm.deletePosition(at: IndexSet(integer: 1))
        
        //Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1000) {
            XCTAssertEqual(1, vm.asset.positions?.count)
            XCTAssertEqual(1, vm.asset.positionCount)
            XCTAssertFalse(vm.asset.positions?.contains(where: {$0.id == position?.id}) ?? false)
        }
    }
}
