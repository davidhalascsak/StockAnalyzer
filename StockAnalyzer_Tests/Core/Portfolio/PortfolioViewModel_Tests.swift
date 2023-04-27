import XCTest

@testable import StockAnalyzer

@MainActor
final class PortfolioViewModel_Tests: XCTestCase {
    func test_PortfolioViewModel_FetchAssets() async throws {
        //Given
        let authUser: AuthUser? = AuthUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let vm = PortfolioViewModel(portfolioService: MockPortfolioService(), sessionService: MockSessionService(currentUser: authUser))
        
        //When
        await vm.fetchAssets()
        
        //Then
        XCTAssertEqual(2, vm.assets.count)
        XCTAssertEqual(2, vm.assetsViewModels.count)
    }
    
    func test_PortfolioViewModel_deleteAsset() async throws {
        //Given
        let authUser: AuthUser? = AuthUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let vm = PortfolioViewModel(portfolioService: MockPortfolioService(), sessionService: MockSessionService(currentUser: authUser))
        
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
