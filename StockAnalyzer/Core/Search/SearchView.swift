import SwiftUI
import FirebaseCore
import FirebaseAuth

struct SearchView: View {
    var body: some View {
        Text(Auth.auth().currentUser?.email ?? "No one is signed in!")
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(MainViewModel(email: "david.halascsak@gmail.com"))
    }
}
