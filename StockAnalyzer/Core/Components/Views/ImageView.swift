import SwiftUI

struct ImageView: View {
    @StateObject var vm: ImageViewModel
    
    init(logoUrl: String) {
        _vm = StateObject(wrappedValue: ImageViewModel(url: logoUrl))
    }
    
    var body: some View {
        if let image = vm.image {
            Image(uiImage: image)
                .resizable()
        } else {
            ProgressView()
        }
    }
}


 struct ImageView_Previews: PreviewProvider {
     static var previews: some View {
         ImageView(logoUrl: "https://financialmodelingprep.com/image-stock/AAPL.png")
     }
 }
