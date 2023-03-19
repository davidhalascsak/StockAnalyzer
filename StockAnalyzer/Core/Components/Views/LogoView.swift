import SwiftUI

struct LogoView: View {
    @StateObject var vm: LogoViewModel
    
    init(logoUrl: String) {
        _vm = StateObject(wrappedValue: LogoViewModel(url: logoUrl))
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


 struct LogoView_Previews: PreviewProvider {
     static var previews: some View {
         LogoView(logoUrl: "https://financialmodelingprep.com/image-stock/AAPL.png")
     }
 }
