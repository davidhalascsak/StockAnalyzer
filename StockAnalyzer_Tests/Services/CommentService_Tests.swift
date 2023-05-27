import XCTest
import Firebase

@testable import StockAnalyzer

final class CommentService_Tets: XCTestCase {

    func test_CommentService_fetchComments() async throws {
        //Given
        let post = Post(id: "19", userRef: "asd321", body: "Good Moring, Vietnam", likeCount: 2, commentCount: 2, stockSymbol: "", timestamp: Timestamp())
        let commentService = MockCommentService(currentUser: nil)
        
        //When
        let comments = await commentService.fetchComments(post: post)
        
        //Then
        XCTAssertEqual(2, comments.count)
    }

    func test_CommentService_checkIfCommentIsliked_True() async throws {
        //Given
        let user = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let comment = Comment(id: "2", userRef: "asd123", body: "Vietnaaam?", timestamp: Timestamp(), likeCount: 5)
        
        let commentService = MockCommentService(currentUser: user)
        
        //When
        let result = await commentService.checkIfCommentIsLiked(comment: comment)
        
        //Then
        XCTAssertTrue(result)
    }
    
    func test_CommentService_checkIfPostIsliked_False() async throws {
        //Given
        let user = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let comment = Comment(id: "1", userRef: "asd123", body: "Guten Morgen", timestamp: Timestamp(), likeCount: 1)
        
        let commentService = MockCommentService(currentUser: user)
        
        //When
        let result = await commentService.checkIfCommentIsLiked(comment: comment)
        
        //Then
        XCTAssertFalse(result)
    }
    
    func test_CommentService_likeComment_UserIsNil() async throws {
        //Given
        let post = Post(id: "19", userRef: "asd321", body: "Good Moring, Vietnam", likeCount: 2, commentCount: 2, stockSymbol: "", timestamp: Timestamp())
        let comment = Comment(id: "1", userRef: "asd123", body: "Guten Morgen", timestamp: Timestamp(), likeCount: 1)
        let commentService = MockCommentService(currentUser: nil)
        
        //When
        let result = await commentService.likeComment(post: post, comment: comment)
        
        //Then
        XCTAssertFalse(result)
    }
    
    func test_CommentService_likeComment_UserIsNotNil() async throws {
        //Given
        let user = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let post = Post(id: "19", userRef: "asd321", body: "Good Moring, Vietnam", likeCount: 2, commentCount: 2, stockSymbol: "", timestamp: Timestamp())
        let comment = Comment(id: "1", userRef: "asd123", body: "Guten Morgen", timestamp: Timestamp(), likeCount: 1)
        let commentService = MockCommentService(currentUser: user)
        
        //When
        let result = await commentService.likeComment(post: post, comment: comment)
        
        //Then
        XCTAssertTrue(result)
    }
    
    func test_CommentService_likeComment_PostIsAlreadyLiked() async throws {
        //Given
        let user = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let post = Post(id: "19", userRef: "asd321", body: "Good Moring, Vietnam", likeCount: 2, commentCount: 2, stockSymbol: "", timestamp: Timestamp())
        let comment = Comment(id: "2", userRef: "asd123", body: "Vietnaaam?", timestamp: Timestamp(), likeCount: 5)
        let commentService = MockCommentService(currentUser: user)
        
        //When
        let result = await commentService.likeComment(post: post, comment: comment)
        
        //Then
        XCTAssertFalse(result)
    }
    
    func test_CommentService_unlikeComment_UserIsNil() async throws {
        //Given
        let post = Post(id: "19", userRef: "asd321", body: "Good Moring, Vietnam", likeCount: 2, commentCount: 2, stockSymbol: "", timestamp: Timestamp())
        let comment = Comment(id: "2", userRef: "asd123", body: "Vietnaaam?", timestamp: Timestamp(), likeCount: 5)
        let commentService = MockCommentService(currentUser: nil)
        
        //When
        let result = await commentService.unlikeComment(post: post, comment: comment)
        
        //Then
        XCTAssertFalse(result)
    }
    
    func test_CommentService_unlikeComment_UserIsNotNil() async throws {
        //Given
        let user = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let post = Post(id: "19", userRef: "asd321", body: "Good Moring, Vietnam", likeCount: 2, commentCount: 2, stockSymbol: "", timestamp: Timestamp())
        let comment = Comment(id: "2", userRef: "asd123", body: "Vietnaaam?", timestamp: Timestamp(), likeCount: 5)
        let commentService = MockCommentService(currentUser: user)
        
        //When
        let result = await commentService.unlikeComment(post: post, comment: comment)
        
        //Then
        XCTAssertTrue(result)
    }
    
    func test_CommentService_unlikeComment_PostisNotLiked() async throws {
        //Given
        let user = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let post = Post(id: "19", userRef: "asd321", body: "Good Moring, Vietnam", likeCount: 2, commentCount: 2, stockSymbol: "", timestamp: Timestamp())
        let comment = Comment(id: "1", userRef: "asd123", body: "Guten Morgen", timestamp: Timestamp(), likeCount: 1)
        let commentService = MockCommentService(currentUser: user)
        
        //When
        let result = await commentService.unlikeComment(post: post, comment: comment)
        
        //Then
        XCTAssertFalse(result)
    }
    
    func test_CommentService_createComment_UserIsNil() async throws {
        //Given
        let post = Post(id: "19", userRef: "asd321", body: "Good Moring, Vietnam", likeCount: 2, commentCount: 2, stockSymbol: "", timestamp: Timestamp())
        let commentService = MockCommentService(currentUser: nil)
        
        //When
        let result = await commentService.createComment(post: post, body: "aaa")
        
        //Then
        XCTAssertFalse(result)
    }
    
    func test_CommentService_createComment_PostNotFound() async throws {
        //Given
        let post = Post(id: "30", userRef: "asd321", body: "Good Moring, Vietnam", likeCount: 2, commentCount: 2, stockSymbol: "", timestamp: Timestamp())
        let commentService = MockCommentService(currentUser: nil)
        
        //When
        let result = await commentService.createComment(post: post, body: "aaa")
        
        //Then
        XCTAssertFalse(result)
    }
    
    func test_CommentService_createComment() async throws {
        //Given
        let user = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let post = Post(id: "19", userRef: "asd321", body: "Good Moring, Vietnam", likeCount: 2, commentCount: 2, stockSymbol: "", timestamp: Timestamp())
        let commentService = MockCommentService(currentUser: user)
        
        //When
        let result = await commentService.createComment(post: post, body: "aaa")
        
        //Then
        XCTAssertTrue(result)
    }
}
