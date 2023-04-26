import XCTest

@testable import StockAnalyzer

@MainActor
final class PositionViewModel_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_PositionViewModel_init() throws {
        //Given
        var asset = Asset(symbol: "AAPL", units: 2.0, averagePrice: 132.5, investedAmount: 265.0, positionCount: 2)
        let position1 = Position(id: UUID().uuidString, symbol: "AAPL", date: "2023-02-02", units: 1, price: 132.5, investedAmount: 132.5)
        let position2 = Position(id: UUID().uuidString, symbol: "AAPL", date: "2023-01-02", units: 1, price: 132.5, investedAmount: 132.5)
        asset.positions = [position1, position2]
        
        //When
        let vm = PositionViewModel(asset: asset, stockService: MockStockService(), portfolioService: MockPortfolioService(), imageService: MockImageService())
        
        //Then
        XCTAssertEqual(vm.asset.symbol, asset.symbol)
        XCTAssertEqual(vm.asset.units, asset.units)
        XCTAssertEqual(vm.asset.averagePrice, asset.averagePrice)
        XCTAssertEqual(vm.asset.investedAmount, asset.investedAmount)
        XCTAssertEqual(vm.asset.positionCount, asset.positionCount)
    }
    
    func test_PositionViewModel_fetchData() async throws {
        //Given
        let asset = Asset(symbol: "AAPL", units: 2.0, averagePrice: 132.5, investedAmount: 265.0, positionCount: 2)
        let vm = PositionViewModel(asset: asset, stockService: MockStockService(), portfolioService: MockPortfolioService(), imageService: MockImageService())
        
        //When
        await vm.fetchData()
        
        //Then
        XCTAssertNotNil(vm.companyProfile)
        XCTAssertNotNil(vm.price)
        XCTAssertFalse(vm.isLoading)
    }

    
    func test_PositionViewModel_changeInPrice() async throws {
        //Given
        let asset = Asset(symbol: "AAPL", units: 2.0, averagePrice: 132.5, investedAmount: 265.0, positionCount: 2)
        let vm = PositionViewModel(asset: asset, stockService: MockStockService(), portfolioService: MockPortfolioService(), imageService: MockImageService())
        
        //When
        await vm.fetchData()
        let change: String = vm.changeInPrice()
        
        //Then
        XCTAssertEqual(change, "10.00(10.00%)")
    }
    
    func test_PositionViewModel_deletePosition() async throws {
        //Given
        var asset = Asset(symbol: "AAPL", units: 2.0, averagePrice: 132.5, investedAmount: 265.0, positionCount: 2)
        let position1 = Position(id: UUID().uuidString, symbol: "AAPL", date: "2023-02-02", units: 1, price: 132.5, investedAmount: 132.5)
        let position2 = Position(id: UUID().uuidString, symbol: "AAPL", date: "2023-01-02", units: 1, price: 132.5, investedAmount: 132.5)
        asset.positions = [position1, position2]
        
        let vm = PositionViewModel(asset: asset, stockService: MockStockService(), portfolioService: MockPortfolioService(), imageService: MockImageService())
        
        //When
        let position = vm.asset.positions?[1]
        await vm.deletePosition(at: 1)
        
        //Then
        XCTAssertEqual(1, vm.asset.positions?.count)
        XCTAssertEqual(1, vm.asset.positionCount)
        XCTAssertFalse(vm.asset.positions?.contains(where: {$0.id == position?.id}) ?? false)
    }
}
