import XCTest
import SwiftUI

@testable import StockAnalyzer

@MainActor
final class FeedBodyViewModel_Tests: XCTestCase {
    func test_FeedBodyViewModel_fetchPosts_SymbolIsEmpty() async throws {
        //Given
        let stockSymbol: String? = nil
        let authUser: TestAuthenticationUser? = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let vm = FeedViewModel(stockSymbol: stockSymbol, userService: MockUserService(), postService: MockPostService(currentUser: authUser), sessionService: MockSessionService(currentUser: nil), imageService: MockImageService())
        
        //When
        await vm.fetchPosts()
        
        //Then
        XCTAssertEqual(2, vm.posts.count)
    }
    
    func test_FeedBodyViewModel_fetchPosts_SymbolIsNotEmpty() async throws {
        //Given
        let stockSymbol: String = "AAPL"
        let authUser: TestAuthenticationUser? = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let vm = FeedViewModel(stockSymbol: stockSymbol, userService: MockUserService(), postService: MockPostService(currentUser: authUser), sessionService: MockSessionService(currentUser: nil), imageService: MockImageService())
        
        //When
        await vm.fetchPosts()
        
        //Then
        XCTAssertEqual(1, vm.posts.count)
    }
}
