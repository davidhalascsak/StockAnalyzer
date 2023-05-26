import XCTest

@testable import StockAnalyzer

@MainActor
final class SearchViewModel_Tests: XCTestCase {
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
        XCTAssertTrue(vm.searchResult.contains(where: {$0.stockSymbol == "AAPL"}))
    }
    
    func test_SearchViewModel_fetchData_resultShouldBeTwo() async throws {
        // Given
        let vm = SearchViewModel(searchService: MockSearchService())
        
        //When
        vm.searchText = "M"
        await vm.fetchData()
        
        //Then
        XCTAssertEqual(2, vm.searchResult.count)
        XCTAssertTrue(vm.searchResult.contains(where: {$0.stockSymbol == "MSFT"}))
        XCTAssertTrue(vm.searchResult.contains(where: {$0.stockSymbol == "MA"}))
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
