import Foundation
import SwiftUI
import Combine

class ImageService: ImageServiceProtocol {
    func fetchData(url: String) async -> UIImage? {
        guard let url = URL(string: url) else {return nil}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            if let image = UIImage(data: data) {
                return image
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return nil
    }
}

protocol ImageServiceProtocol {
    func fetchData(url: String) async -> UIImage?
}
