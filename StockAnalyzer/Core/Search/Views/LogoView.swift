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
                .frame(width: 40, height: 40)
            /*
                .padding()
            
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 0.5)
                )
             */
        } else if vm.isLoading {
            ProgressView()
        } else {
            Rectangle()
                .fill(Color.black)
                .frame(width: 40, height: 40)
        }
    }
}


 struct LogoView_Previews: PreviewProvider {
     static var previews: some View {
         LogoView(logo: "https://financialmodelingprep.com/image-stock/AAPL.png")
     }
 }
