import Foundation
import Combine
import SwiftUI

@MainActor
class ImageViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var image: UIImage?
    
    let url: String
    let imageService: ImageServiceProtocol
    
    init(url: String, imageService: ImageServiceProtocol) {
        self.url = url
        self.imageService = imageService
    }
    
    func fetchData() async {
        let data = await self.imageService.fetchData(url: self.url)
        if let data = data {
            self.image = self.imageService.convertDataToImage(imageData: data)
        }
        self.isLoading = false
    }
}
