import Foundation
import Combine
import SwiftUI

class LogoViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var image: UIImage? = nil
    
    let imageService: ImageService
    
    var cancellables = Set<AnyCancellable>()
    
    init(url: String) {
        self.imageService = ImageService(url: url)
        self.isLoading = true
        fetchData()
    }
    
    
    func fetchData() {
        self.imageService.$image
            .sink { [weak self] image in
                self?.image = image
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
}
