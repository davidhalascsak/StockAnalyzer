import SwiftUI

struct FeedBodyView: View {
    @StateObject var vm: FeedBodyViewModel
    @Binding var isNewViewPresented: Bool
    
    init(symbol: String, isNewViewPresented: Binding<Bool>) {
        _vm = StateObject(wrappedValue: FeedBodyViewModel(symbol: symbol))
        _isNewViewPresented = isNewViewPresented
    }
    
    
    var body: some View {
        LazyVStack {
            ForEach(vm.posts) { post in
                PostView(post: post)
                Divider()
            }
        }
        .onAppear(perform: vm.fetchPosts)
        .onChange(of: isNewViewPresented) { newValue in
            if newValue == false {
                vm.isLoading = true
                vm.fetchPosts()
            }
        }
    }
}

struct FeedBodyView_Previews: PreviewProvider {
    @State static var isNewViewPresented: Bool = false
    
    static var previews: some View {
        FeedBodyView(symbol: "Apple", isNewViewPresented: $isNewViewPresented)
    }
}
