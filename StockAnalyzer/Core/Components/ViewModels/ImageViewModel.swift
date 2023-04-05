import Foundation
import Combine
import SwiftUI

class ImageViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var image: UIImage? = nil
    
    let imageService: ImageServiceProtocol
    
    init(imageService: ImageServiceProtocol) {
        self.imageService = imageService
    }
    
    func fetchData() async {
        self.image = await self.imageService.fetchData()
        self.isLoading = false
    }
}
