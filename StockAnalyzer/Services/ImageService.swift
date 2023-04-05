import Foundation
import SwiftUI
import Combine

class ImageService: ImageServiceProtocol {
    let url: String
    
    init(url: String) {
        self.url = url
    }
    
    func fetchData() async -> UIImage? {
        guard let url = URL(string: self.url) else {return nil}
        
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
    func fetchData() async -> UIImage?
}
