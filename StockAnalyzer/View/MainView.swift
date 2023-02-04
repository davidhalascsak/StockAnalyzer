import SwiftUI
import FirebaseCore
import FirebaseAuth

struct MainView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Button {
                    do {
                        try Auth.auth().signOut()
                        print("logged out successfully")
                    } catch let error {
                        print(error)
                    }
                    dismiss()
                } label: {
                    Text("logout")
                }
                Text(Auth.auth().currentUser?.email ?? "No one is signed in!")
        }
        .toolbar(.hidden)
    }
}

struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
