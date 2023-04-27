import XCTest

@testable import StockAnalyzer

@MainActor
final class NewPostViewModel_Tests: XCTestCase {
    func test_NewViewModel_CreatePost() async throws {
        //Given
        let symbol: String? = "Apple"
        let authUser: AuthUser? = AuthUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let vm = NewPostViewModel(symbol: symbol, postService: MockPostService(currentUser: authUser))
        
        //When
        vm.postBody = "Apple is going to become obsole, if they do not release AR glasses!!!"
        await vm.createPost()
        
        //Then
        XCTAssertFalse(vm.showAlert)
        XCTAssertEqual("", vm.postBody)
        
    }
}
