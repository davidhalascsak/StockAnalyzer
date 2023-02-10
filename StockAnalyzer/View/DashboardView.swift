import SwiftUI
import FirebaseCore
import FirebaseAuth

struct DashboardView: View {
    @EnvironmentObject private var vm: MainViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.blue
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
                        .font(.headline)
                        .foregroundColor(Color.black)
                }
                Text(vm.userEmail)
            }
        }
       
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environmentObject(MainViewModel(email: "david.halascsak@gmail.com"))
    }
}
