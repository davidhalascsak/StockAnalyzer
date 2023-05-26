import XCTest
import Firebase

@testable import StockAnalyzer

@MainActor
final class CommentViewModel_Tests: XCTestCase {
    
    func test_CommentViewModel_likeComment_NotLiked() async throws {
        let post = Post(id: "19", userRef: "asd321", body: "Good Moring, Vietnam", likeCount: 2, commentCount: 2, timestamp: Timestamp())
        let comment = Comment(id: "1", userRef: "asd123", body: "Guten Morgen", timestamp: Timestamp(), likeCount: 1)
        let authUser: TestAuthenticationUser? = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let vm = CommentViewModel(post: post, comment: comment, commentService: MockCommentService(currentUser: authUser), sessionService: MockSessionService(currentUser: authUser))
        
        //When
        await vm.likeComment()
        
        //Then
        XCTAssertEqual(vm.comment.likeCount, comment.likeCount + 1)
    }
    
    func test_CommentViewModel_likeComment_Liked() async throws {
        //Given
        let post = Post(id: "19", userRef: "asd321", body: "Good Moring, Vietnam", likeCount: 2, commentCount: 2, timestamp: Timestamp())
        let comment = Comment(id: "2", userRef: "asd123", body: "Vietnaaam?", timestamp: Timestamp(), likeCount: 5)
        let authUser: TestAuthenticationUser? = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let vm = CommentViewModel(post: post, comment: comment, commentService: MockCommentService(currentUser: authUser), sessionService: MockSessionService(currentUser: authUser))
        
        //When
        await vm.likeComment()
        
        //Then
        XCTAssertEqual(vm.comment.likeCount, comment.likeCount)
    }
    
    func test_CommentViewModel_unlikeComment_Liked() async throws {
        //Given
        let post = Post(id: "19", userRef: "asd321", body: "Good Moring, Vietnam", likeCount: 2, commentCount: 2, timestamp: Timestamp())
        let comment = Comment(id: "2", userRef: "asd123", body: "Vietnaaam?", timestamp: Timestamp(), likeCount: 5)
        let authUser: TestAuthenticationUser? = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let vm = CommentViewModel(post: post, comment: comment, commentService: MockCommentService(currentUser: authUser), sessionService: MockSessionService(currentUser: authUser))
        
        //When
        await vm.unlikeComment()
        
        //Then
        XCTAssertEqual(vm.comment.likeCount, comment.likeCount - 1)
    }
    
    func test_CommentViewModel_unlikeComment_NotLiked() async throws {
        let post = Post(id: "19", userRef: "asd321", body: "Good Moring, Vietnam", likeCount: 2, commentCount: 2, timestamp: Timestamp())
        let comment = Comment(id: "1", userRef: "asd123", body: "Guten Morgen", timestamp: Timestamp(), likeCount: 1)
        let authUser: TestAuthenticationUser? = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let vm = CommentViewModel(post: post, comment: comment, commentService: MockCommentService(currentUser: authUser), sessionService: MockSessionService(currentUser: authUser))
        
        //When
        await vm.unlikeComment()
        
        //Then
        XCTAssertEqual(vm.comment.likeCount, comment.likeCount)
    }
}
