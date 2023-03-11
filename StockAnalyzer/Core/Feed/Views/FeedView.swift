import SwiftUI
import FirebaseCore
import FirebaseAuth

struct FeedView: View {
    @EnvironmentObject var sessionService: SessionService
    @StateObject var vm: FeedViewModel
    
    init(showHeader: Bool) {
        _vm = StateObject(wrappedValue: FeedViewModel(showHeader: showHeader))
    }
    
    @State var isNewPostPresented: Bool = false
    @State var isSettingsPresented: Bool = false

    var body: some View {
        VStack {
            if(vm.showHeader) {
                feedHeader
            }
            if vm.isLoading == false {
                feedBody
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
                            vm.isLoading = true
                            vm.fetchPosts()
                        }
                    }
            } else {
                Spacer()
                ProgressView()
                Spacer()
            }
        }
        .onAppear(perform: vm.fetchPosts)
    }
    
    var feedHeader: some View {
        HStack() {
            Image(systemName: "arrow.triangle.2.circlepath")
                .font(.title2)
                .onTapGesture {
                    withAnimation {
                        vm.isLoading = true
                        vm.fetchPosts()
                        vm.shouldScroll.toggle()
                    }
                }
                .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)
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

    var feedBody: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                Divider().id("top")
                LazyVStack {
                    ForEach(vm.posts) { post in
                        PostView(post: post)
                        Divider()
                    }
                    .onChange(of: vm.shouldScroll) { _ in
                        withAnimation(.spring()) {
                            proxy.scrollTo("top")
                        }
                    }
                }
            }
            .overlay(alignment: .bottomTrailing, content: {
                if vm.showHeader && sessionService.session != nil {
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
        }
    }
}



struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(showHeader: true)
            .environmentObject(SessionService.entity)
    }
}

