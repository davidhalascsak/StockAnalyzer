import SwiftUI
import FirebaseCore
import FirebaseAuth

struct FeedView: View {
    @StateObject var vm = FeedViewModel()

    var body: some View {
        ScrollView() {
            ForEach(vm.posts) { post in
                PostView(post: post)
                Divider()
            }
        }
        .scrollIndicators(.hidden)        
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}

