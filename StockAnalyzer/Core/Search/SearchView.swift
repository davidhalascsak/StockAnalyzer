import SwiftUI
import FirebaseCore
import FirebaseAuth

struct SearchView: View {
    @State var isSettingsPresented: Bool = false
    var body: some View {
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
        }
        .fullScreenCover(isPresented: $isSettingsPresented, content: {
            SettingsView()
        })
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
