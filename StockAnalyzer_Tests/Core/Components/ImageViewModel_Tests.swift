import XCTest


@testable import StockAnalyzer

@MainActor
final class ImageViewModel_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_ImageViewModel_init_ShouldWork() throws {
        //Given
        let url: String = "https://test.com/testpicture"
        let defaultImage = "default_avatar"
        
        //When
        let vm = ImageViewModel(url: url, defaultImage: defaultImage, imageService: MockImageService())
        
        //Then
        XCTAssertEqual("https://test.com/testpicture", vm.url)
        XCTAssertEqual("default_avatar", vm.defaultImage)
    }
    
    func test_ImageViewModel_fetchData_ShouldWorkWithGoodUrl() async throws {
        //Given
        let url: String = "https://test.com/testpicture"
        let defaultImage: String = "default_avatar"
        
        //When
        let vm = ImageViewModel(url: url, defaultImage: defaultImage, imageService: MockImageService())
        await vm.fetchData()
        
        //Then
        XCTAssertNotNil(vm.image)
        XCTAssertFalse(vm.isLoading)
    }
    
    func test_ImageViewModel_fetchData_ShouldWorkWithBadUrl() async throws {
        //Given
        let url: String = "testimage/data"
        let defaultImage: String = "default_avatar"
        
        //When
        let vm = ImageViewModel(url: url, defaultImage: defaultImage, imageService: MockImageService())
        await vm.fetchData()
        
        //Then
        XCTAssertNotNil(vm.image)
        XCTAssertFalse(vm.isLoading)
    }
    
    func test_ImageViewModel_fetchData_ShouldReturnNil() async throws {
        //Given
        let url: String = ""
        let defaultImage: String = ""
        
        //When
        let vm = ImageViewModel(url: url, defaultImage: defaultImage, imageService: MockImageService())
        await vm.fetchData()
        
        //Then
        XCTAssertNil(vm.image)
        XCTAssertFalse(vm.isLoading)
    }
}
