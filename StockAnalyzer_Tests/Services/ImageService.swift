import XCTest

@testable import StockAnalyzer

final class ImageService_Tests: XCTestCase {
    func test_ImageService_fetchImageData_validUrl() async throws {
        //Given
        let imageService = MockImageService()
        
        //When
        let data = imageService.fetchImageData(url: "https://test_image.com")
        
        //Then
        XCTAssertNotNil(data)
    }
    
    func test_ImageService_fetchImageData_notValidUrl() throws {
        //Given
        let imageService = MockImageService()
        
        //When
        let data = imageService.fetchImageData(url: "htps://test_image.com")
        
        //Then
        XCTAssertNil(data)
    }
    
    func test_ImageService_convertDataToImage_validData() async throws {
        //Given
        let imageService = MockImageService()
        
        //When
        let data = imageService.fetchImageData(url: "https://test_image.com")
        let image = imageService.convertDataToImage(imageData: data)
        
        //Then
        XCTAssertNotNil(image)
    }
    
    func test_ImageService_convertDataToImage_notValidData() throws {
        //Given
        let imageService = MockImageService()
        
        //When
        let data = Data()
        let image = imageService.convertDataToImage(imageData: data)
        
        //Then
        XCTAssertNil(data)
    }
}
