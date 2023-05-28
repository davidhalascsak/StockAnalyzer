import SwiftUI
import FirebaseCore
import FirebaseAuth

struct NewsView: View {
    @State private var isSettingsPresented: Bool = false
    
    @StateObject private var viewModel: NewsViewModel
    
    init(newsService: NewsServiceProtocol) {
        _viewModel = StateObject(wrappedValue: NewsViewModel(newsService: newsService))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
                .padding(.bottom, 5)
            Divider()
            if viewModel.isLoading == false {
                feedView
            } else {
                Spacer()
                ProgressView()
                Spacer()
            }
            Divider()
                .padding(.bottom, 5)
        }
        .task {
            viewModel.isLoading = true
            await viewModel.fetchNews()
        }
    }
    
    var headerView: some View {
        HStack() {
            Image(systemName: "arrow.triangle.2.circlepath")
                .font(.title2)
                .onTapGesture {
                    withAnimation {
                        viewModel.isLoading = true
                        Task {
                           await viewModel.fetchNews()
                        }
                        viewModel.shouldScroll.toggle()
                    }
                }
                .disabled(viewModel.isLoading)
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
    
    var feedView: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                Divider().id("top")
                LazyVStack(alignment: .leading) {
                    ForEach(viewModel.news, id: \.self) { news in
                        if let url = URL(string: news.news_url) {
                            Link(destination: url) {
                                NewsRowView(news: news)
                                    .padding(.horizontal, 5)
                            }
                            Divider()
                        }
                    }
                }
                .onChange(of: viewModel.shouldScroll) { _ in
                    withAnimation(.spring()) {
                        proxy.scrollTo("top")
                    }
                }
            }
            .fullScreenCover(isPresented: $isSettingsPresented, content: {
                SettingsView(userService: UserService(), sessionService: SessionService(), imageService: ImageService())
            })
        }
    }
}

struct WatchlistView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView(newsService: MockNewsService(stockSymbol: nil))
    }
}
