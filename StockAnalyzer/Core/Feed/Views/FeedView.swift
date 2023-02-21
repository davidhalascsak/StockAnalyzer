import SwiftUI
import FirebaseCore
import FirebaseAuth

struct FeedView: View {
    @StateObject var vm = FeedViewModel()
    @State var isNewPostPresented: Bool = false
    @State var shouldScroll: Bool = false
    

    var body: some View {
        VStack {
            Divider()
            HStack {
                Button {
                    withAnimation(.easeOut) {
                        vm.fetchPosts()
                        shouldScroll.toggle()
                    }
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .padding([.leading], 12)
                        .padding([.vertical], 2)
                }
                Spacer()
            }
            ScrollViewReader { reader in
                ScrollView(showsIndicators: false) {
                    Divider().id("top")
                    LazyVStack {
                        ForEach(vm.posts) { post in
                            PostView(post: post)
                            Divider()
                        }
                        .onChange(of: shouldScroll) { _ in
                            withAnimation(.spring()) {
                                reader.scrollTo("top")
                            }
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
                .onChange(of: vm.isNewPostPresented) { newValue in
                    if newValue == false {
                        vm.fetchPosts()
                    }
                }
            }
            
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}

