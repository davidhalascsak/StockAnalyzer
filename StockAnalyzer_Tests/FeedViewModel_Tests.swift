import XCTest

@testable import StockAnalyzer

@MainActor
final class FeedViewModel_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_FeedViewModel_Tests() async throws {
        //Given
        let vm = FeedViewModel(userService: MockUserService(), postService: MockPostService(), sessionService: MockSessionService(), imageService: MockImageService())
        
        //When
        await vm.fetchPosts()
        
        //Then
        XCTAssertEqual(2, vm.posts.count)
    }
}
