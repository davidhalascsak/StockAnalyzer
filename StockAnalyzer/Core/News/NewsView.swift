import SwiftUI
import FirebaseCore
import FirebaseAuth

struct NewsView: View {
    var body: some View {
        Text(Auth.auth().currentUser?.email ?? "No one is signed in!")
    }
}

struct WatchlistView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
            .environmentObject(MainViewModel(email: "david.halascsak@gmail.com"))
    }
}
