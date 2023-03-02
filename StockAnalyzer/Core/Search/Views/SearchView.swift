import SwiftUI
import FirebaseCore
import FirebaseAuth

struct SearchView: View {
    @State var isSettingsPresented: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                headerView
                Spacer()
                NavigationLink(destination: StockView(symbol: "TSLA")) {
                    Text("AAPL")
                }
            }
            .fullScreenCover(isPresented: $isSettingsPresented, content: {
                SettingsView()
            })
        }
    }
    
    var headerView: some View {
        HStack() {
            Spacer()
            Text("Search")
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

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
