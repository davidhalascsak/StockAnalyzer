import SwiftUI

struct LogoView: View {
    @StateObject var vm: LogoViewModel
    
    init(logo: String) {
        _vm = StateObject(wrappedValue: LogoViewModel(logo))
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
         LogoView(logo: "https://financialmodelingprep.com/image-stock/AAPL.png")
     }
 }
