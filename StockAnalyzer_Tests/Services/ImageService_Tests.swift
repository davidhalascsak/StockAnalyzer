import XCTest

@testable import StockAnalyzer

final class ImageService_Tests: XCTestCase {
    func test_ImageService_fetchImageData_validUrl() async throws {
        //Given
        let imageService = MockImageService()
        
        //When
        let data = await imageService.fetchImageData(url: "https://test_image.com")
        
        //Then
        XCTAssertNotNil(data)
    }
    
    func test_ImageService_fetchImageData_notValidUrl() async throws {
        //Given
        let imageService = MockImageService()
        
        //When
        let data = await imageService.fetchImageData(url: "htt:/test_image.cm")
        
        //Then
        XCTAssertNotNil(data)
    }
    
    func test_ImageService_convertDataToImage_validData() async throws {
        //Given
        let imageService = MockImageService()
        
        //When
        let data = await imageService.fetchImageData(url: "https://test_image.com") ?? Data()
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
        XCTAssertNil(image)
    }
    
    func test_ImageService_uploadImage_validData() async throws {
        //Given
        let imageService = MockImageService()
        var result: String?
        //When
        let image = UIImage(named: "default_avatar")
        if let image = image {
            result = await imageService.uploadImage(image: image)
        }
        
        //Then
        XCTAssertNotNil(result)
    }
    
    func test_ImageService_uploadImage_notValidData() async throws {
        //Given
        let imageService = MockImageService()
        var result: String?
        //When
        let image = UIImage(named: "")
        if let image = image {
            result = await imageService.uploadImage(image: image)
        }
        
        //Then
        XCTAssertNil(result)
    }
    
    func test_ImageService_deleteImage_validUrl() async throws {
        //Given
        let imageService = MockImageService()
        
        //When
        let result = await imageService.deleteImage(url: "https://test_image.com")
        
        //Then
        XCTAssertTrue(result)
    }
    
    func test_ImageService_deleteImage_notValidUrl() async throws {
        //Given
        let imageService = MockImageService()
        
        //When
        let result = await imageService.deleteImage(url: "http://test_image.com")
        
        //Then
        XCTAssertFalse(result)
    }
    
    func test_ImageService_updateImage_validUrlAndData() async throws {
        //Given
        let imageService = MockImageService()
        
        //When
        let data = await imageService.fetchImageData(url: "https://test_image.com") ?? Data()
        let result = await imageService.updateImage(url: "https://test_image.com", data: data)
        
        //Then
        XCTAssertTrue(result)
    }
    
    func test_ImageService_updateImage_notValidUrl() async throws {
        //Given
        let imageService = MockImageService()
        
        //When
        let data = await imageService.fetchImageData(url: "https://test_image.com") ?? Data()
        let result = await imageService.updateImage(url: "http://test_image.co", data: data)
        
        //Then
        XCTAssertFalse(result)
    }
    
    func test_ImageService_updateImage_notValidData() async throws {
        //Given
        let imageService = MockImageService()
        
        //When
        let data = Data()
        let result = await imageService.updateImage(url: "https://test_image.com", data: data)
        
        //Then
        XCTAssertFalse(result)
    }
}
