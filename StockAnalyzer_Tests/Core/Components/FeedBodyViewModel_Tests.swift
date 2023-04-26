import XCTest
import SwiftUI

@testable import StockAnalyzer

@MainActor
final class FeedBodyViewModel_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_FeedBodyViewModel_init_symbolShouldBeEmpty() throws {
        func test_ImageViewModel_init_ShouldWork() throws {
            //Given
            let symbol: String = ""
            
            //When
            let vm = FeedBodyViewModel(symbol: symbol, userService: MockUserService(), postService: MockPostService(), imageService: MockImageService())
            
            //Then
            XCTAssertEqual("", vm.symbol)
        }
    }
    
    func test_FeedBodyViewModel_init_symbolShouldBeNotEmpty() throws {
        //Given
        let symbol: String = "AAPL"
        
        //When
        let vm = FeedBodyViewModel(symbol: symbol, userService: MockUserService(), postService: MockPostService(), imageService: MockImageService())
        
        //Then
        XCTAssertEqual("AAPL", vm.symbol)
    }
    
    func test_FeedBodyViewModel_fetchPosts_SymbolIsEmpty() async throws {
        //Given
        let symbol: String? = nil
        let vm = FeedBodyViewModel(symbol: symbol, userService: MockUserService(), postService: MockPostService(), imageService: MockImageService())
        
        //When
        await vm.fetchPosts()
        
        //Then
        XCTAssertEqual(2, vm.posts.count)
    }
    
    func test_FeedBodyViewModel_fetchPosts_SymbolIsNotEmpty() async throws {
        //Given
        let symbol: String = "AAPL"
        let vm = FeedBodyViewModel(symbol: symbol, userService: MockUserService(), postService: MockPostService(), imageService: MockImageService())
        
        //When
        await vm.fetchPosts()
        
        //Then
        XCTAssertEqual(1, vm.posts.count)
    }
}
