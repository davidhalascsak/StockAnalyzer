import SwiftUI

struct MainView: View {
    @State private var selectedTab: MenuOptions = MenuOptions.home
    
    private enum MenuOptions: Hashable {
        case home
        case news
        case portfolio
        case search
    }
    
    init() {
        UITabBar.appearance().isTranslucent = false
    }
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                FeedView(userService: UserService(), postService: PostService(), sessionService: SessionService(), imageService: ImageService())
                    .tabItem {
                        Image(systemName: "house")
                    }
                    .tag(MenuOptions.home)
                NewsView(newsService: NewsService(symbol: nil))
                    .tabItem {
                        Image(systemName: "newspaper") 
                    }
                    .tag(MenuOptions.news)
                PortfolioView(portfolioService: PortfolioService(), sessionService: SessionService())
                    .tabItem {
                        Image(systemName: "briefcase")
                    }
                    .tag(MenuOptions.portfolio)
                SearchView(searchService: SearchService())
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                    }
                    .tag(MenuOptions.search)
            }
            .toolbar(.hidden)
        }
    }
}

struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
