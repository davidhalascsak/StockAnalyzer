import XCTest


@testable import StockAnalyzer

@MainActor
final class ImageViewModel_Tests: XCTestCase {
    func test_ImageViewModel_fetchData_ShouldWorkWithGoodUrl() async throws {
        //Given
        let url: String = "https://test.com/testpicture"
        let defaultImage: String = "default_avatar"
        
        //When
        let vm = ImageViewModel(url: url, defaultImage: defaultImage, imageService: MockImageService())
        await vm.fetchImage()
        
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
        await vm.fetchImage()
        
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
        await vm.fetchImage()
        
        //Then
        XCTAssertNil(vm.image)
        XCTAssertFalse(vm.isLoading)
    }
}
