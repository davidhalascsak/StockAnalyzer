import SwiftUI

struct ImageView: View {
    @StateObject var vm: ImageViewModel
    
    init(url: String, imageService: ImageServiceProtocol) {
        _vm = StateObject(wrappedValue: ImageViewModel(url: url, imageService: imageService))
    }
    
    var body: some View {
        VStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                ProgressView()
            }
        }
        .task {
            vm.isLoading = true
            await vm.fetchData()
        }
    }
}


 struct ImageView_Previews: PreviewProvider {
     static var previews: some View {
         ImageView(url: "https://financialmodelingprep.com/image-stock/AAPL.png", imageService: ImageService())
     }
 }
