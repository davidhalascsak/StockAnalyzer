import SwiftUI
import FirebaseCore
import FirebaseAuth

struct PortfolioView: View {
    @State var isSettingsPresented: Bool = false
    var body: some View {
        VStack {
            headerView
            Divider()
            Spacer()
        }
        .fullScreenCover(isPresented: $isSettingsPresented, content: {
            SettingsView()
        })
    }
    
    var headerView: some View {
        HStack {
            Image(systemName: "arrow.triangle.2.circlepath")
                .font(.title2)
                .opacity(0)
            Spacer()
            Text("Portfolio")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color.blue)
            Spacer()
            Image(systemName: "person.crop.circle")
                .font(.title2)
                .onTapGesture {
                    self.isSettingsPresented.toggle()
                }
        }
        .padding(.horizontal)
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
    }
}
