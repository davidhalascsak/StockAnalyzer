import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var vm: MainViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Settings")
                Text(vm.userEmail)
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Image(systemName: "xmark")
                        .onTapGesture {
                            vm.isSettingsPresented.toggle()
                        }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(MainViewModel(email: "david.halascsak@gmail.com"))
    }
}
