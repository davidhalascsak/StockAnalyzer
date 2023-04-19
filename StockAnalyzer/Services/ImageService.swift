import Foundation
import SwiftUI
import Combine
import FirebaseStorage

class ImageService: ImageServiceProtocol {
    func fetchData(url: String) async -> Data? {
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
            print(error)
        }
        
        return nil
    }
}

protocol ImageServiceProtocol {
    func fetchData(url: String) async -> Data?
    func convertDataToImage(imageData: Data) -> UIImage?
    func uploadImage(image: UIImage) async -> String?
}
