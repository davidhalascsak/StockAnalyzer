import XCTest
import SwiftUI

@testable import StockAnalyzer

@MainActor
final class FeedBodyViewModel_Tests: XCTestCase {
    func test_FeedBodyViewModel_fetchPosts_SymbolIsEmpty() async throws {
        //Given
        let symbol: String? = nil
        let authUser: AuthUser? = AuthUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let vm = FeedBodyViewModel(symbol: symbol, userService: MockUserService(), postService: MockPostService(currentUser: authUser), imageService: MockImageService())
        
        //When
        await vm.fetchPosts()
        
        //Then
        XCTAssertEqual(2, vm.posts.count)
    }
    
    func test_FeedBodyViewModel_fetchPosts_SymbolIsNotEmpty() async throws {
        //Given
        let symbol: String = "AAPL"
        let authUser: AuthUser? = AuthUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let vm = FeedBodyViewModel(symbol: symbol, userService: MockUserService(), postService: MockPostService(currentUser: authUser), imageService: MockImageService())
        
        //When
        await vm.fetchPosts()
        
        //Then
        XCTAssertEqual(1, vm.posts.count)
    }
}
