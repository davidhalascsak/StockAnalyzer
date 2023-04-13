import Foundation
import Combine
import SwiftUI

@MainActor
class ImageViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var image: UIImage? = nil
    
    let url: String
    let imageService: ImageServiceProtocol
    
    init(url: String, imageService: ImageServiceProtocol) {
        self.url = url
        self.imageService = imageService
    }
    
    func fetchData() async {
        self.image = await self.imageService.fetchData(url: self.url)
        self.isLoading = false
    }
}
