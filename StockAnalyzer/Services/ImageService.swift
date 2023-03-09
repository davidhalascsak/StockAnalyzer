import Foundation
import SwiftUI
import Combine

class ImageService: ObservableObject {
    @Published var image: UIImage?
    
    let imageUrl: String
    var imageSubscription: AnyCancellable?
    
    init(url: String) {
        self.imageUrl = url
        downloadImage()
    }
    
    func downloadImage() {
        guard let url = URL(string: self.imageUrl) else {return}
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedImage) in
                guard let self = self, let downloadedImage = returnedImage else { return }
                self.image = downloadedImage
                self.imageSubscription?.cancel()
            })
    }
}
