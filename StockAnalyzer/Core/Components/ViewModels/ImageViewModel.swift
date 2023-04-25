import Foundation
import SwiftUI

@MainActor
class ImageViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var image: UIImage?
    
    let url: String
    let imageService: ImageServiceProtocol
    let defaultImage: String
    
    init(url: String, defaultImage: String, imageService: ImageServiceProtocol) {
        self.url = url
        self.defaultImage = defaultImage
        self.imageService = imageService
    }
    
    func fetchData() async {
        let data = await self.imageService.fetchImageData(url: self.url)
        if let data = data {
            self.image = self.imageService.convertDataToImage(imageData: data)
        } else if self.defaultImage != "" {
            self.image = UIImage(named: self.defaultImage)
        }
        self.isLoading = false
    }
}
