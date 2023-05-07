import SwiftUI

struct MainView: View {
    @State var selectedTab: String = "Home"
    
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
                    .tag("Home")
                NewsView(newsService: NewsService(symbol: nil))
                    .tabItem {
                        Image(systemName: "newspaper") 
                    }
                    .tag("News")
                PortfolioView(portfolioService: PortfolioService(), sessionService: SessionService())
                    .tabItem {
                        Image(systemName: "briefcase")
                    }
                    .tag("Portfolio")
                SearchView(searchService: SearchService())
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                    }
                    .tag("Search")
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
