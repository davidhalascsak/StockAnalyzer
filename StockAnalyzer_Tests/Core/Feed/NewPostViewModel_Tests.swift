import XCTest

@testable import StockAnalyzer

@MainActor
final class NewPostViewModel_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_NewPostViewModel_init_EmptySymbol() throws {
        //Given
        let symbol: String? = nil
        
        //When
        let vm = NewPostViewModel(symbol: symbol, postService: MockPostService())
        
        //then
        XCTAssertEqual(symbol, vm.symbol)
    }
    
    func test_NewPostViewModel_init_NotEmptySymbol() throws {
        //Given
        let symbol: String? = "Apple"
        
        
        //When
        let vm = NewPostViewModel(symbol: symbol, postService: MockPostService())
        
        //Then
        XCTAssertEqual(symbol, vm.symbol)
    }
    
    func test_NewViewModel_init_CreatePost() async throws {
        //Given
        let symbol: String? = "Apple"
        let vm = NewPostViewModel(symbol: symbol, postService: MockPostService())
        
        //When
        vm.postBody = "Apple is going to become obsole, if they do not release AR glasses!!!"
        await vm.createPost()
        
        //Then
        XCTAssertFalse(vm.showAlert)
        XCTAssertEqual("", vm.postBody)
        
    }
}
