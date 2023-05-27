import XCTest

@testable import StockAnalyzer

final class PortfolioService_Tests: XCTestCase {
    
    func test_PortfolioService_fetchAssets() async throws {
        // GIVEN
        let portfolioService = MockPortfolioService()
        
        //WHEN
        let assets = await portfolioService.fetchAssets()
        
        //THEN
        XCTAssertEqual(2, assets.count)
    }
    
    func test_PortfolioService_fetchPositions() async throws {
        // GIVEN
        let portfolioService = MockPortfolioService()
        
        //WHEN
        let positions = await portfolioService.fetchPositions(stockSymbol: "AAPL")
        
        //THEN
        XCTAssertEqual(2, positions.count)
    }
    
    func test_PortfolioService_deleteAsset() async throws {
        // GIVEN
        let portfolioService = MockPortfolioService()
        
        //WHEN
        let result = await portfolioService.deleteAsset(stockSymbol: "AAPL")
        let assets = await portfolioService.fetchAssets()
        
        //THEN
        XCTAssertTrue(result)
        XCTAssertEqual(1, assets.count)
    }
    
    func test_PortfolioService_deletePosition_lastPosition() async throws {
        // GIVEN
        let asset = Asset(stockSymbol: "AAPL", units: 2.0, averagePrice: 132.5, positionCount: 2)
        let position = Position(id: "1", date: "2023-02-02", units: 1, price: 132.5)
        let portfolioService = MockPortfolioService()
        
        //WHEN
        let result = await portfolioService.deletePosition(asset: asset, position: position)
        let assets = await portfolioService.fetchAssets()
        
        //THEN
        XCTAssertTrue(result)
        XCTAssertEqual(2, assets.count)
    }
    
    func test_PortfolioService_deleteAsset_notLastPosition() async throws {
        // GIVEN
        let asset = Asset(stockSymbol: "MSFT", units: 3.0, averagePrice: 230.0, positionCount: 1)
        let position = Position(id: "3", date: "2020-02-02", units: 3.0, price: 230.0)
        let portfolioService = MockPortfolioService()
        
        //WHEN
        let result = await portfolioService.deletePosition(asset: asset, position: position)
        let assets = await portfolioService.fetchAssets()
        
        //THEN
        XCTAssertTrue(result)
        XCTAssertEqual(1, assets.count)
    }
    
    func test_PortfolioService_addPosition_assetNotExistsYet() async throws {
        // GIVEN
        let position = Position(id: "4", date: "2020-02-02", units: 3.0, price: 230.0)
        let portfolioService = MockPortfolioService()
        
        //WHEN
        let result = await portfolioService.addPosition(stockSymbol: "NVDA", position: position)
        let assets = await portfolioService.fetchAssets()
        let asset = assets.first(where: {$0.stockSymbol == "NVDA"})
        
        //THEN
        XCTAssertTrue(result)
        XCTAssertEqual(3, assets.count)
        XCTAssertEqual(3, asset?.units)
        XCTAssertEqual(230, asset?.averagePrice)
    }
    
    func test_PortfolioService_addPosition_assetAlreadyExists() async throws {
        // GIVEN
        let position = Position(id: "4", date: "2020-02-02", units: 3.0, price: 132.5)
        let portfolioService = MockPortfolioService()
        
        //WHEN
        let result = await portfolioService.addPosition(stockSymbol: "AAPL", position: position)
        let assets = await portfolioService.fetchAssets()
        let asset = assets.first(where: {$0.stockSymbol == "AAPL"})
        
        //THEN
        XCTAssertTrue(result)
        XCTAssertEqual(2, assets.count)
        XCTAssertEqual(5, asset?.units)
        XCTAssertEqual(132.5, asset?.averagePrice)
    }
}
