import Foundation
import SwiftUI

@MainActor
class ImageViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var image: UIImage?
    
    let url: String
    let imageService: ImageServiceProtocol
    let defaultImage: String?
    
    init(url: String, defaultImage: String?, imageService: ImageServiceProtocol) {
        self.url = url
        self.defaultImage = defaultImage
        self.imageService = imageService
    }
    
    func fetchImage() async {
        let data = await imageService.fetchImageData(url: url)
        if let data = data {
            image = imageService.convertDataToImage(imageData: data)
        } else if let defaultImage = self.defaultImage {
            image = UIImage(named: defaultImage)
        }
        isLoading = false
    }
}
