import XCTest
import Firebase

@testable import StockAnalyzer

@MainActor
final class CommentSectionViewModel_Tests: XCTestCase {
    func test_CommentSectionViewModel_fetchComments() async throws {
        // Given
        let post = Post(id: "19", userRef: "asd321", body: "Good Moring, Vietnam", timestamp: Timestamp(), likes: 2, comments: 2, symbol: "")
        let authUser: TestAuthenticationUser? = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let vm = CommentSectionViewModel(post: post, commentService: MockCommentService(currentUser: authUser), userService: MockUserService(), sessionService: MockSessionService(currentUser: authUser))
        
        //When
        await vm.fetchComments()
        
        //Then
        XCTAssertEqual(2, vm.comments.count)
        XCTAssertFalse(vm.isLoading)
    }
    
    func test_CommentSectionViewModel_createComment_PostExist() async throws {
        let post = Post(id: "19", userRef: "asd321", body: "Good Moring, Vietnam", timestamp: Timestamp(), likes: 2, comments: 2, symbol: "")
        let authUser: TestAuthenticationUser? = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let vm = CommentSectionViewModel(post: post, commentService: MockCommentService(currentUser: authUser), userService: MockUserService(), sessionService: MockSessionService(currentUser: authUser))
        
        //When
        vm.commentBody = "I totally agree with you upon this."
        await vm.createComment()
        
        //Then
        XCTAssertFalse(vm.showAlert)
        XCTAssertEqual("",vm.alertTitle)
        XCTAssertEqual("",vm.alertText)
        XCTAssertEqual("",vm.commentBody)
    }
    
    func test_CommentSectionViewModel_createComment_PostNotExist() async throws {
        let post = Post(id: "40", userRef: "asd321", body: "Good Moring, Vietnam", timestamp: Timestamp(), likes: 2, comments: 2, symbol: "")
        let authUser: TestAuthenticationUser? = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let vm = CommentSectionViewModel(post: post, commentService: MockCommentService(currentUser: authUser), userService: MockUserService(), sessionService: MockSessionService(currentUser: authUser))
        
        //When
        vm.commentBody = "I totally agree with you upon this."
        await vm.createComment()
        
        //Then
        XCTAssertTrue(vm.showAlert)
        XCTAssertEqual("Error",vm.alertTitle)
        XCTAssertEqual("Error while adding the comment.",vm.alertText)
        XCTAssertEqual("",vm.commentBody)
    }
}
