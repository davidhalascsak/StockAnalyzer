import SwiftUI
import FirebaseCore
import FirebaseAuth

struct SearchView: View {
    @State var isSettingsPresented: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
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
                Spacer()
                NavigationLink(destination: StockView(symbol: "ADS")) {
                    Text("AAPL")
                }
            }
            .fullScreenCover(isPresented: $isSettingsPresented, content: {
                SettingsView()
            })
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
