import Foundation
import SwiftUI
import FirebaseStorage

class ImageService: ImageServiceProtocol {
    private var storage = Storage.storage()
    
    func fetchImageData(url: String) async -> Data? {
        guard let url = URL(string: url) else {return nil}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            return data
        } catch {
            return nil
        }
    }
    
    func convertDataToImage(imageData: Data) -> UIImage? {
        return UIImage(data: imageData)
    }
    
    func uploadImage(image: UIImage) async -> String? {
        guard let compressedImage = image.jpegData(compressionQuality: 0.5) else {return nil}
        
        let fileName = NSUUID().uuidString
        let reference = storage.reference(withPath: "/pictures/\(fileName)")
        
        do {
            _ = try await reference.putDataAsync(compressedImage)
            let url = try await reference.downloadURL()
            
            return url.absoluteString
        } catch {
            return nil
        }
    }
    
    func deleteImage(url: String) async -> Bool {
        let reference = storage.reference(forURL: url)
        do {
            try await reference.delete()
            return true
        } catch {
            return false
        }
    }
    
    func updateImage(url: String, data: Data) async -> Bool {
        guard let image = UIImage(data: data) else {return false}
        guard let compressedImage = image.jpegData(compressionQuality: 0.5) else {return false}
        
        let reference = storage.reference(forURL: url)
        
        do {
            _ = try await reference.putDataAsync(compressedImage)
            
            return true
        } catch {
            return false
        }
    }
}


class MockImageService: ImageServiceProtocol {
    var db: MockDatabase = MockDatabase()
    
    func fetchImageData(url: String) async -> Data? {
        guard URL(string: url) != nil else {return nil}
        guard let image = UIImage(named: "default_avatar") else {return nil}
        guard let data = image.jpegData(compressionQuality: 0.5) else {return nil}
        
        return data
    }
    
    func convertDataToImage(imageData: Data) -> UIImage? {
        return UIImage(data: imageData)
    }
    
    func uploadImage(image: UIImage) async -> String? {
        guard let data = image.jpegData(compressionQuality: 0.5) else {return nil}
        
        let imageUrl = UUID().uuidString
        db.imageUrls[imageUrl] = data
        
        return imageUrl
    }
    
    func deleteImage(url: String) async -> Bool {
        let result = db.imageUrls.removeValue(forKey: url)
        return (result == nil) ? false : true
    }
    
    func updateImage(url: String, data: Data) async -> Bool {
        if db.imageUrls.contains(where: {$0.key == url}) && !data.isEmpty {
            db.imageUrls[url] = data
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
    func deleteImage(url: String) async -> Bool
    func updateImage(url: String, data: Data) async -> Bool
}
