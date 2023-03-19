import Foundation
import SwiftUI
import Combine

class ImageService: ObservableObject {
    @Published var image: UIImage?
    
    let url: String
    var cancellables = Set<AnyCancellable>()
    
    init(url: String) {
        self.url = url
        fetchData()
    }
    
    func fetchData() {
        guard let url = URL(string: self.url) else {return}
        
        NetworkingManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedImage) in
                guard let self = self, let downloadedImage = returnedImage else { return }
                self.image = downloadedImage
            })
            .store(in: &cancellables)
    }
}
