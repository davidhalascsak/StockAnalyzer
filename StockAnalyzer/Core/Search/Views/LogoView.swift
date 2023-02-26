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
            
        } else if vm.isLoading {
            ProgressView()
        } else {
            Circle()
                .fill(Color.black)
        }
    }
}

/*
 struct LogoView_Previews: PreviewProvider {
 static var previews: some View {
 LogoView()
 }
 }
 */
