import Foundation
import Combine
import SwiftUI

class LogoViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var image: UIImage? = nil
    let logo: String
    
    var imageSubscription: AnyCancellable?
    
    init(_ logo: String) {
        self.logo = logo
        self.isLoading = true
        downloadImage()
    }
    
    
    func downloadImage() {
        guard let url = URL(string: self.logo) else {return}
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedImage) in
                guard let self = self, let downloadedImage = returnedImage else { return }
                self.image = downloadedImage
                self.isLoading = false
                self.imageSubscription?.cancel()
            })
    }
}
