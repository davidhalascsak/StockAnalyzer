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
                .padding(2)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 0.5)
                )
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
