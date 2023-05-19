import XCTest
import Firebase

@testable import StockAnalyzer

@MainActor
final class PostViewModel_Tests: XCTestCase {
    func test_PostViewModel_likePost_PostExistAndLiked() async throws {
        //Given
        let post = Post(id: "19", userRef: "asd321", body: "Good Moring, Vietnam", timestamp: Timestamp(), likes: 2, comments: 1, symbol: "")
        let authUser: TestAuthenticationUser? = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let vm = PostViewModel(post: post, postService: MockPostService(currentUser: authUser), sessionService: MockSessionService(currentUser: authUser))
        
        //When
        await vm.likePost()
        
        //Then
        XCTAssertEqual(post.likeCount, vm.post.likeCount)
        XCTAssertTrue(vm.isUpdated)
    }
    
    func test_PostViewModel_likePost_PostExistAndNotLiked() async throws {
        //Given
        let post = Post(id: "22", userRef: "asd123", body: "I like Ike", timestamp: Timestamp(), likes: 0, comments: 0, symbol: "AAPL")
        let authUser: TestAuthenticationUser? = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let vm = PostViewModel(post: post, postService: MockPostService(currentUser: authUser), sessionService: MockSessionService(currentUser: authUser))
        
        //When
        await vm.likePost()
        
        //Then
        XCTAssertEqual(post.likeCount + 1, vm.post.likeCount)
        XCTAssertTrue(vm.isUpdated)
    }
    
    func test_PostViewModel_unlikePost_PostExistAndLiked() async throws {
        //Given
        let post = Post(id: "19", userRef: "asd321", body: "Good Moring, Vietnam", timestamp: Timestamp(), likes: 2, comments: 1, symbol: "")
        let authUser: TestAuthenticationUser? = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let vm = PostViewModel(post: post, postService: MockPostService(currentUser: authUser), sessionService: MockSessionService(currentUser: authUser))
        
        //When
        await vm.unlikePost()
        
        //Then
        XCTAssertEqual(post.likeCount - 1, vm.post.likeCount)
        XCTAssertTrue(vm.isUpdated)
    }
    
    func test_PostViewModel_unlikePost_PostExistAndNotLiked() async throws {
        //Given
        let post = Post(id: "22", userRef: "asd123", body: "I like Ike", timestamp: Timestamp(), likes: 0, comments: 0, symbol: "AAPL")
        let authUser: TestAuthenticationUser? = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let vm = PostViewModel(post: post, postService: MockPostService(currentUser: authUser), sessionService: MockSessionService(currentUser: authUser))
        
        //When
        await vm.unlikePost()
        
        //Then
        XCTAssertEqual(post.likeCount, vm.post.likeCount)
        XCTAssertTrue(vm.isUpdated)
    }
    
    func test_PostViewModel_likePost_PostNotExist() async throws {
        //Given
        let post = Post(id: "25", userRef: "asd123", body: "I like Ike", timestamp: Timestamp(), likes: 0, comments: 0, symbol: "AAPL")
        let authUser: TestAuthenticationUser? = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let vm = PostViewModel(post: post, postService: MockPostService(currentUser: authUser), sessionService: MockSessionService(currentUser: authUser))
        //When
        await vm.unlikePost()
        
        //Then
        XCTAssertEqual(post.likeCount, vm.post.likeCount)
        XCTAssertTrue(vm.isUpdated)
    }
    
    func test_PostViewModel_unlikePost_PostNotExist() async throws {
        //Given
        let post = Post(id: "25", userRef: "asd123", body: "I like Ike", timestamp: Timestamp(), likes: 0, comments: 0, symbol: "AAPL")
        let authUser: TestAuthenticationUser? = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let vm = PostViewModel(post: post, postService: MockPostService(currentUser: authUser), sessionService: MockSessionService(currentUser: authUser))
        
        //When
        await vm.unlikePost()
        
        //Then
        XCTAssertEqual(post.likeCount, vm.post.likeCount)
        XCTAssertTrue(vm.isUpdated)
    }
    
    func test_PostViewModel_likePost_CurrentUserIsNil() async throws {
        let post = Post(id: "22", userRef: "asd123", body: "I like Ike", timestamp: Timestamp(), likes: 0, comments: 0, symbol: "AAPL")
        let authUser: TestAuthenticationUser? = nil
        let vm = PostViewModel(post: post, postService: MockPostService(currentUser: authUser), sessionService: MockSessionService(currentUser: authUser))
        
        //When
        await vm.likePost()
        
        //Then
        XCTAssertEqual(post.likeCount, vm.post.likeCount)
        XCTAssertTrue(vm.isUpdated)
    }
    
    func test_PostViewModel_unlikePost_CurrentUserIsNil() async throws {
        let post = Post(id: "19", userRef: "asd321", body: "Good Moring, Vietnam", timestamp: Timestamp(), likes: 2, comments: 1, symbol: "")
        let authUser: TestAuthenticationUser? = nil
        let vm = PostViewModel(post: post, postService: MockPostService(currentUser: authUser), sessionService: MockSessionService(currentUser: authUser))
        
        //When
        await vm.unlikePost()
        
        //Then
        XCTAssertEqual(post.likeCount, vm.post.likeCount)
        XCTAssertTrue(vm.isUpdated)
    }
}
