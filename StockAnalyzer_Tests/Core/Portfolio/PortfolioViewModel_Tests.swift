import XCTest

@testable import StockAnalyzer

@MainActor
final class PortfolioViewModel_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_PortfolioViewModel_FetchAssets() async throws {
        //Given
        let vm = PortfolioViewModel(portfolioService: MockPortfolioService(), sessionService: MockSessionService())
        
        //When
        await vm.fetchAssets()
        
        //Then
        XCTAssertEqual(2, vm.assets.count)
        XCTAssertEqual(2, vm.assetsViewModels.count)
    }
    
    func test_PortfolioViewModel_deleteAsset() async throws {
        //Given
        let vm = PortfolioViewModel(portfolioService: MockPortfolioService(), sessionService: MockSessionService())
        
        //When
        await vm.fetchAssets()
        let asset = vm.assets[0]
        await vm.deleteAsset(at: 0)
        
        //
        XCTAssertEqual(1, vm.assets.count)
        XCTAssertEqual(1, vm.assetsViewModels.count)
        XCTAssertFalse(vm.assets.contains(where: {$0.symbol == asset.symbol}))
    }
}
