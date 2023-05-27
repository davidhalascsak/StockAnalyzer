import XCTest
import Firebase

@testable import StockAnalyzer

final class PostService_Tets: XCTestCase {

    func test_PostService_fetchPosts_symbolIsNil() async throws {
        //Given
        let postService = MockPostService(currentUser: nil)
        
        //When
        let posts = await postService.fetchPosts(stockSymbol: nil)
        
        //Then
        XCTAssertEqual(2, posts.count)
    }
    
    func test_PostService_fetchPosts_symbolIsNotNil() async throws {
        //Given
        let postService = MockPostService(currentUser: nil)
        
        //When
        let posts = await postService.fetchPosts(stockSymbol: "AAPL")
        
        //Then
        XCTAssertEqual(1, posts.count)
    }
    
    func test_PostService_checkIfPostIsliked_True() async throws {
        //Given
        let user = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let post = Post(id: "19", userRef: "asd321", body: "Good Moring, Vietnam", likeCount: 2, commentCount: 2, stockSymbol: "", timestamp: Timestamp())
        let postService = MockPostService(currentUser: user)
        
        //When
        let result = await postService.checkIfPostIsLiked(post: post)
        
        //Then
        XCTAssertTrue(result)
    }
    
    func test_PostService_checkIfPostIsliked_False() async throws {
        //Given
        let user = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let post = Post(id: "22", userRef: "asd123", body: "I like Ike",likeCount: 0, commentCount: 0, stockSymbol: "AAPL", timestamp: Timestamp())
        let postService = MockPostService(currentUser: user)
        
        //When
        let result = await postService.checkIfPostIsLiked(post: post)
        
        //Then
        XCTAssertFalse(result)
    }
    
    func test_PostService_likePost_UserIsNil() async throws {
        //Given
        let post = Post(id: "22", userRef: "asd123", body: "I like Ike",likeCount: 0, commentCount: 0, stockSymbol: "AAPL", timestamp: Timestamp())
        let postService = MockPostService(currentUser: nil)
        
        //When
        let result = await postService.likePost(post: post)
        
        //Then
        XCTAssertFalse(result)
    }
    
    func test_PostService_likePost_UserIsNotNil() async throws {
        //Given
        let user = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let post = Post(id: "22", userRef: "asd123", body: "I like Ike",likeCount: 0, commentCount: 0, stockSymbol: "AAPL", timestamp: Timestamp())
        let postService = MockPostService(currentUser: user)
        
        //When
        let result = await postService.likePost(post: post)
        
        //Then
        XCTAssertTrue(result)
    }
    
    func test_PostService_likePost_PostIsAlreadyLiked() async throws {
        //Given
        let user = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let post = Post(id: "19", userRef: "asd321", body: "Good Moring, Vietnam", likeCount: 2, commentCount: 2, stockSymbol: "", timestamp: Timestamp())
        let postService = MockPostService(currentUser: user)
        
        //When
        let result = await postService.likePost(post: post)
        
        //Then
        XCTAssertFalse(result)
    }
    
    func test_PostService_unlikePost_UserIsNil() async throws {
        //Given
        let post = Post(id: "22", userRef: "asd123", body: "I like Ike",likeCount: 0, commentCount: 0, stockSymbol: "AAPL", timestamp: Timestamp())
        let postService = MockPostService(currentUser: nil)
        
        //When
        let result = await postService.likePost(post: post)
        
        //Then
        XCTAssertFalse(result)
    }
    
    func test_PostService_unlikePost_UserIsNotNil() async throws {
        //Given
        let user = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let post = Post(id: "19", userRef: "asd321", body: "Good Moring, Vietnam", likeCount: 2, commentCount: 2, stockSymbol: "", timestamp: Timestamp())
        let postService = MockPostService(currentUser: user)
        
        //When
        let result = await postService.unlikePost(post: post)
        
        //Then
        XCTAssertTrue(result)
    }
    
    func test_PostService_unlikePost_PostisNotLiked() async throws {
        //Given
        let user = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let post = Post(id: "22", userRef: "asd123", body: "I like Ike",likeCount: 0, commentCount: 0, stockSymbol: "AAPL", timestamp: Timestamp())
        let postService = MockPostService(currentUser: user)
        
        //When
        let result = await postService.unlikePost(post: post)
        
        //Then
        XCTAssertFalse(result)
    }
    
    func test_PostService_createPost_UserIsNil() async throws {
        //Given
        let postService = MockPostService(currentUser: nil)
        
        //When
        let result = await postService.createPost(body: "aaa", stockSymbol: nil)
        
        //Then
        XCTAssertFalse(result)
    }
    
    func test_PostService_createPost_SymbolNil() async throws {
        //Given
        let user = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let postService = MockPostService(currentUser: user)
        
        //When
        let result = await postService.createPost(body: "aaa", stockSymbol: nil)
        
        //Then
        XCTAssertTrue(result)
    }
    
    func test_PostService_createPost_SymbolNotNil() async throws {
        //Given
        let user = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let postService = MockPostService(currentUser: user)
        
        //When
        let result = await postService.createPost(body: "aaa", stockSymbol: "AAPL")
        
        //Then
        XCTAssertTrue(result)
    }
}
