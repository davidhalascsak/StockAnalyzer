import SwiftUI
import FirebaseCore
import FirebaseAuth

struct NewsView: View {
    @State var isSettingsPresented: Bool = false
    var body: some View {
        VStack {
            HStack() {
                Spacer()
                Text("News")
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
        .fullScreenCover(isPresented: $isSettingsPresented, content: {
            SettingsView()
        })
    }
}

struct WatchlistView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}
