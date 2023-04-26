import XCTest

@testable import StockAnalyzer

@MainActor
final class SearchViewModel_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_SearchViewModel_fetchData_resultShouldBeEmpty() async throws {
        // Given
        let vm = SearchViewModel(searchService: MockSearchService())
        
        //When
        vm.searchText = ""
        await vm.fetchData()
        
        //Then
        XCTAssertEqual(0, vm.searchResult.count)
    }
    
    func test_SearchViewModel_fetchData_resultShouldBeOne() async throws {
        // Given
        let vm = SearchViewModel(searchService: MockSearchService())
        
        //When
        vm.searchText = "A"
        await vm.fetchData()
        
        //Then
        XCTAssertEqual(1, vm.searchResult.count)
        XCTAssertTrue(vm.searchResult.contains(where: {$0.symbol == "AAPL"}))
    }
    
    func test_SearchViewModel_fetchData_resultShouldBeTwo() async throws {
        // Given
        let vm = SearchViewModel(searchService: MockSearchService())
        
        //When
        vm.searchText = "M"
        await vm.fetchData()
        
        //Then
        XCTAssertEqual(2, vm.searchResult.count)
        XCTAssertTrue(vm.searchResult.contains(where: {$0.symbol == "MSFT"}))
        XCTAssertTrue(vm.searchResult.contains(where: {$0.symbol == "MA"}))
    }
    
    func test_SearchViewModel_resetSearch() async throws {
        // Given
        let vm = SearchViewModel(searchService: MockSearchService())
        vm.searchText = "M"
        await vm.fetchData()
        
        //When
        vm.resetSearch()
        
        
        //Then
        XCTAssertEqual("", vm.searchText)
        XCTAssertEqual(0, vm.searchResult.count)
    }
}
