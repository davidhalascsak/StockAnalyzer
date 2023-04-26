import XCTest
import Firebase

@testable import StockAnalyzer

@MainActor
final class CommentViewModel_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_CommentViewModel_init() throws {
        //Given
        let post = Post(id: "19", userRef: "asd321", body: "Good Moring, Vietnam", timestamp: Timestamp(), likes: 2, comments: 2, symbol: "")
        let comment = Comment(id: "2", userRef: "asd123", body: "Vietnaaam?", timestamp: Timestamp(), likes: 5)
        
        //When
        let vm = CommentViewModel(post: post, comment: comment, commentService: MockCommentService(), sessionService: MockSessionService())
        
        //Then
        XCTAssertEqual(vm.post.id, post.id)
        XCTAssertEqual(vm.comment.id, comment.id)
    }
    
    func test_CommentViewModel_likeComment_NotLiked() async throws {
        let post = Post(id: "19", userRef: "asd321", body: "Good Moring, Vietnam", timestamp: Timestamp(), likes: 2, comments: 2, symbol: "")
        let comment = Comment(id: "1", userRef: "asd123", body: "Guten Morgen", timestamp: Timestamp(), likes: 1)
        let vm = CommentViewModel(post: post, comment: comment, commentService: MockCommentService(), sessionService: MockSessionService())
        
        //When
        await vm.likeComment()
        
        //Then
        XCTAssertEqual(vm.comment.likes, comment.likes + 1)
    }
    
    func test_CommentViewModel_likeComment_Liked() async throws {
        //Given
        let post = Post(id: "19", userRef: "asd321", body: "Good Moring, Vietnam", timestamp: Timestamp(), likes: 2, comments: 2, symbol: "")
        let comment = Comment(id: "2", userRef: "asd123", body: "Vietnaaam?", timestamp: Timestamp(), likes: 5)
        let vm = CommentViewModel(post: post, comment: comment, commentService: MockCommentService(), sessionService: MockSessionService())
        
        //When
        await vm.likeComment()
        
        //Then
        XCTAssertEqual(vm.comment.likes, comment.likes)
    }
    
    func test_CommentViewModel_unlikeComment_Liked() async throws {
        //Given
        let post = Post(id: "19", userRef: "asd321", body: "Good Moring, Vietnam", timestamp: Timestamp(), likes: 2, comments: 2, symbol: "")
        let comment = Comment(id: "2", userRef: "asd123", body: "Vietnaaam?", timestamp: Timestamp(), likes: 5)
        let vm = CommentViewModel(post: post, comment: comment, commentService: MockCommentService(), sessionService: MockSessionService())
        
        //When
        await vm.unlikeComment()
        
        //Then
        XCTAssertEqual(vm.comment.likes, comment.likes - 1)
    }
    
    func test_CommentViewModel_unlikeComment_NotLiked() async throws {
        let post = Post(id: "19", userRef: "asd321", body: "Good Moring, Vietnam", timestamp: Timestamp(), likes: 2, comments: 2, symbol: "")
        let comment = Comment(id: "1", userRef: "asd123", body: "Guten Morgen", timestamp: Timestamp(), likes: 1)
        let vm = CommentViewModel(post: post, comment: comment, commentService: MockCommentService(), sessionService: MockSessionService())
        
        //When
        await vm.unlikeComment()
        
        //Then
        XCTAssertEqual(vm.comment.likes, comment.likes)
    }
}
