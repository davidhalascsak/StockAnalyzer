import SwiftUI
import FirebaseCore
import FirebaseAuth

struct FeedView: View {
    @EnvironmentObject var sessionService: SessionService
    @StateObject var vm = FeedViewModel()
    
    @State var isNewPostPresented: Bool = false
    @State var isSettingsPresented: Bool = false

    var body: some View {
        VStack {
            feedHeader
            ScrollViewReader { reader in
                ScrollView(showsIndicators: false) {
                    Divider().id("top")
                    LazyVStack {
                        ForEach(vm.posts) { post in
                            PostView(post: post)
                            Divider()
                        }
                        .onChange(of: vm.shouldScroll) { _ in
                            withAnimation(.spring()) {
                                reader.scrollTo("top")
                            }
                        }
                    }
                }
                .overlay(alignment: .bottomTrailing, content: {
                    if sessionService.session != nil {
                        Image(systemName: "pencil")
                            .font(.title)
                            .foregroundColor(Color.white)
                            .frame(width: 50, height: 50)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .padding()
                            .onTapGesture {
                                vm.isNewPostPresented.toggle()
                            }
                    }
                })
                .fullScreenCover(isPresented: $isNewPostPresented, content: {
                    NewPostView()
                })
                .fullScreenCover(isPresented: $isSettingsPresented, content: {
                    SettingsView()
                })
                .sync($vm.isNewPostPresented, with: $isNewPostPresented)
                .sync($vm.isSettingsPresented, with: $isSettingsPresented)
                .onChange(of: vm.isNewPostPresented) { newValue in
                    if newValue == false {
                        vm.fetchPosts()
                    }
                }
                .onAppear(perform: vm.fetchPosts)
            }
        }
    }
    
    var feedHeader: some View {
        HStack() {
            Image(systemName: "arrow.triangle.2.circlepath")
                .font(.title2)
                .onTapGesture {
                    vm.fetchPosts()
                    vm.shouldScroll.toggle()
                }
            Spacer()
            Text("Feed")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color.blue)
            Spacer()
            Image(systemName: "person.crop.circle")
                .font(.title2)
                .onTapGesture {
                    self.isSettingsPresented.toggle()
                }
        }
        .padding(.horizontal)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
            .environmentObject(SessionService.entity)
    }
}

