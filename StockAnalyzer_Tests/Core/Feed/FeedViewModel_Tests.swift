import XCTest

@testable import StockAnalyzer

@MainActor
final class FeedViewModel_Tests: XCTestCase {
    func test_FeedViewModel_fetchPosts() async throws {
        //Given
        let authUser: TestAuthenticationUser? = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let vm = FeedViewModel(stockSymbol: nil, userService: MockUserService(), postService: MockPostService(currentUser: authUser), sessionService: MockSessionService(currentUser: authUser), imageService: MockImageService())
        
        //When
        await vm.fetchPosts()
        
        //Then
        XCTAssertEqual(2, vm.posts.count)
        XCTAssertFalse(vm.isLoading)
    }
}
