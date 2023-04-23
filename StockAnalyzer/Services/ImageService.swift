import Foundation
import SwiftUI
import FirebaseStorage

class ImageService: ImageServiceProtocol {
    func fetchImageData(url: String) async -> Data? {
        guard let url = URL(string: url) else {return nil}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            return data
        } catch let error {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    func convertDataToImage(imageData: Data) -> UIImage? {
        return UIImage(data: imageData)
    }
    
    func uploadImage(image: UIImage) async -> String? {
        guard let compressedImage = image.jpegData(compressionQuality: 0.5) else {return nil}
        
        let fileName = NSUUID().uuidString
        let reference = Storage.storage().reference(withPath: "/pictures/\(fileName)")
        
        do {
            _ = try await reference.putDataAsync(compressedImage)
            let url = try await reference.downloadURL()
            
            return url.absoluteString
        } catch let error {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    func updateImage(url: String, data: Data) async -> Bool {
        guard let image = UIImage(data: data) else {return false}
        guard let compressedImage = image.jpegData(compressionQuality: 0.5) else {return false}
        
        let reference = Storage.storage().reference(forURL: url)
        
        do {
            _ = try await reference.putDataAsync(compressedImage)
            
            return true
        } catch let error {
            print(error.localizedDescription)
        }
        
        return false
    }
}


class MockImageService: ImageServiceProtocol {
    var imageUrls: [String: Data] = [:]
    
    init() {
        let image = UIImage(named: "default_avatar")
        let data = image?.jpegData(compressionQuality: 0.5)
        imageUrls["https://test_image.com"] = data ?? Data()
    }
    
    func fetchImageData(url: String) async -> Data? {
        guard URL(string: url) != nil else {return nil}
        
        if Bool.random() {
            guard let image = UIImage(named: "default_avatar") else {return nil}
            
            guard let data = image.jpegData(compressionQuality: 0.5) else {return nil}
            
            return data
        } else {
            return nil
        }
    }
    
    func convertDataToImage(imageData: Data) -> UIImage? {
        return UIImage(data: imageData)
    }
    
    func uploadImage(image: UIImage) async -> String? {
        guard let image = UIImage(named: "default_avatar") else {return nil}
        guard let data = image.jpegData(compressionQuality: 0.5) else {return nil}
        
        let imageUrl = UUID().uuidString
        imageUrls[imageUrl] = data
        
        return imageUrl
    }
    
    func updateImage(url: String, data: Data) async -> Bool {
        if self.imageUrls.contains(where: {$0.key == url}) && !data.isEmpty {
            self.imageUrls[url] = data
            return true
        } else {
            return false
        }
    }
    
    
}

protocol ImageServiceProtocol {
    func fetchImageData(url: String) async -> Data?
    func convertDataToImage(imageData: Data) -> UIImage?
    func uploadImage(image: UIImage) async -> String?
    func updateImage(url: String, data: Data) async -> Bool
}
