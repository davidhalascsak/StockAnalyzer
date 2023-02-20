import SwiftUI
import FirebaseCore
import FirebaseAuth

struct FeedView: View {
    @ObservedObject var vm = FeedViewModel()
    @State var isNewPostPresented: Bool = false
    

    var body: some View {
        ScrollView() {
            LazyVStack {
                ForEach(vm.posts) { post in
                    PostView(post: post)
                    Divider()
                }
            }
        }
        .overlay(alignment: .bottomTrailing, content: {
            Image(systemName: "pencil")
                .foregroundColor(Color.white)
                .frame(width: 60, height: 60)
                .background(Color.blue)
                .clipShape(Circle())
                .padding()
                .onTapGesture {
                    vm.isNewPostPresented.toggle()
                }
        })
        .fullScreenCover(isPresented: $isNewPostPresented, content: {
            NewPostView()
        })
        .sync($vm.isNewPostPresented, with: $isNewPostPresented)
        .scrollIndicators(.hidden)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}

