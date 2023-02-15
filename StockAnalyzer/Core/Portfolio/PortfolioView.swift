import SwiftUI
import FirebaseCore
import FirebaseAuth

struct PortfolioView: View {
    var body: some View {
        Text(Auth.auth().currentUser?.email ?? "No one is signed in!")
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(MainViewModel(email: "david.halascsak@gmail.com"))
    }
}
