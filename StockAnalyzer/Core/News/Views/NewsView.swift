import SwiftUI
import FirebaseCore
import FirebaseAuth

struct NewsView: View {
    @StateObject var vm: NewsViewModel
    @State var isSettingsPresented: Bool = false
    
    init(newsService: NewsServiceProtocol) {
        _vm = StateObject(wrappedValue: NewsViewModel(newsService: NewsService(symbol: nil)))
    }
    
    var body: some View {
        VStack {
            headerView
            if vm.isLoading == false {
                newsBody
            } else {
                Spacer()
                ProgressView()
                Spacer()
            }
        }
        .task {
            vm.isLoading = true
            await vm.fetchNews()
        }
    }
    
    var headerView: some View {
        HStack() {
            Image(systemName: "arrow.triangle.2.circlepath")
                .font(.title2)
                .onTapGesture {
                    withAnimation {
                        vm.isLoading = true
                        Task {
                           await vm.fetchNews()
                        }
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
        NewsView(newsService: NewsService(symbol: nil))
    }
}
