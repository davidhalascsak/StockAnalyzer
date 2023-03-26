import SwiftUI
import FirebaseCore
import FirebaseAuth

struct NewsView: View {
    @StateObject var vm = NewsViewModel()
    @State var isSettingsPresented: Bool = false
    var body: some View {
        VStack {
            newsHeader
            if vm.isLoading == false {
                newsBody
            } else {
                Spacer()
                ProgressView()
                Spacer()
            }
            
        }
    }
    
    var newsHeader: some View {
        HStack() {
            Image(systemName: "arrow.triangle.2.circlepath")
                .font(.title2)
                .onTapGesture {
                    withAnimation {
                        vm.reloadData()
                        vm.shouldScroll.toggle()
                    }
                }
                .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)
            Spacer()
            Text("News")
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
    
    var newsBody: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                Divider().id("top")
                LazyVStack(alignment: .leading) {
                    ForEach(vm.news, id: \.self) { news in
                        if URL(string: news.news_url) != nil {
                            NewsRowView(news: news)
                                .padding(.horizontal, 5)
                            Divider()
                        }
                    }
                }
                .onChange(of: vm.shouldScroll) { _ in
                    withAnimation(.spring()) {
                        proxy.scrollTo("top")
                    }
                }
            }
            .fullScreenCover(isPresented: $isSettingsPresented, content: {
                SettingsView(userService: UserService())
            })
        }
    }
}

struct WatchlistView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}
