import SwiftUI

struct ImageView: View {
    @StateObject private var viewModel: ImageViewModel
    
    init(url: String, defaultImage: String, imageService: ImageServiceProtocol) {
        _viewModel = StateObject(wrappedValue: ImageViewModel(url: url, defaultImage: defaultImage, imageService: imageService))
    }
    
    var body: some View {
        VStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Rectangle()
                }
            }
        }
        .task {
            viewModel.isLoading = true
            await viewModel.fetchData()
        }
    }
}


 struct ImageView_Previews: PreviewProvider {
     static var previews: some View {
         ImageView(url: "https://financialmodelingprep.com/image-stock/AAPL.png", defaultImage: "", imageService: ImageService())
     }
 }
