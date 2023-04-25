import XCTest
import Firebase

@testable import StockAnalyzer

@MainActor
final class PostViewModel_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_PostViewModel_init() throws {
        // Given
        let post = Post(id: "19", userRef: "asd321", body: "Good Moring, Vietnam", timestamp: Timestamp(), likes: 2, comments: 1, symbol: "")
        
        //When
        let vm = PostViewModel(post: post, postService: MockPostService(), sessionService: MockSessionService())
        
        //Then
        XCTAssertEqual(post.id, vm.post.id)
    }

    func test_PostViewModel_likePost_PostExistAndLiked() async throws {
        //Given
        let post = Post(id: "19", userRef: "asd321", body: "Good Moring, Vietnam", timestamp: Timestamp(), likes: 2, comments: 1, symbol: "")
        let vm = PostViewModel(post: post, postService: MockPostService(), sessionService: MockSessionService())
        
        //When
        await vm.likePost()
        
        //Then
        XCTAssertEqual(post.likes, vm.post.likes)
        XCTAssertTrue(vm.isUpdated)
    }
    
    func test_PostViewModel_likePost_PostExistAndNotLiked() async throws {
        //Given
        let post = Post(id: "22", userRef: "asd123", body: "I like Ike", timestamp: Timestamp(), likes: 0, comments: 0, symbol: "AAPL")
        let vm = PostViewModel(post: post, postService: MockPostService(), sessionService: MockSessionService())
        
        //When
        await vm.likePost()
        
        //Then
        XCTAssertEqual(post.likes + 1, vm.post.likes)
        XCTAssertTrue(vm.isUpdated)
    }
    
    func test_PostViewModel_unlikePost_PostExistAndLiked() async throws {
        //Given
        let post = Post(id: "19", userRef: "asd321", body: "Good Moring, Vietnam", timestamp: Timestamp(), likes: 2, comments: 1, symbol: "")
        let vm = PostViewModel(post: post, postService: MockPostService(), sessionService: MockSessionService())
        
        //When
        await vm.unlikePost()
        XCTAssertEqual(post.likes - 1, vm.post.likes)
        XCTAssertTrue(vm.isUpdated)
    }
    
    func test_PostViewModel_unlikePost_PostExistAndNotLiked() async throws {
        //Given
        let post = Post(id: "22", userRef: "asd123", body: "I like Ike", timestamp: Timestamp(), likes: 0, comments: 0, symbol: "AAPL")
        let vm = PostViewModel(post: post, postService: MockPostService(), sessionService: MockSessionService())
        
        //When
        await vm.unlikePost()
        XCTAssertEqual(post.likes, vm.post.likes)
        XCTAssertTrue(vm.isUpdated)
    }
    
    func test_PostViewModel_likePost_PostNotExist() async throws {
        //Given
        let post = Post(id: "25", userRef: "asd123", body: "I like Ike", timestamp: Timestamp(), likes: 0, comments: 0, symbol: "AAPL")
        let vm = PostViewModel(post: post, postService: MockPostService(), sessionService: MockSessionService())
        
        //When
        await vm.unlikePost()
        XCTAssertEqual(post.likes, vm.post.likes)
        XCTAssertTrue(vm.isUpdated)
    }
    
    func test_PostViewModel_unlikePost_PostNotExist() async throws {
        //Given
        let post = Post(id: "25", userRef: "asd123", body: "I like Ike", timestamp: Timestamp(), likes: 0, comments: 0, symbol: "AAPL")
        let vm = PostViewModel(post: post, postService: MockPostService(), sessionService: MockSessionService())
        
        //When
        await vm.unlikePost()
        XCTAssertEqual(post.likes, vm.post.likes)
        XCTAssertTrue(vm.isUpdated)
    }
}
