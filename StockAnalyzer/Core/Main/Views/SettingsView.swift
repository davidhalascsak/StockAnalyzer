import SwiftUI

struct SettingsView: View {
    @Binding var isSettingsPresented: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Settings")
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Image(systemName: "xmark")
                        .onTapGesture {
                            isSettingsPresented.toggle()
                        }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    @State static var isPresented = false
    
    static var previews: some View {
        SettingsView(isSettingsPresented: $isPresented)
    }
}
