import SwiftUI
import FirebaseCore
import FirebaseAuth

struct MainView: View {
    @State var isSettingsPresented: Bool = false
    @State var selectedTab: String = "Home"
    @State var goFeedTop: Bool = false
    
    init() {
        UITabBar.appearance().isTranslucent = false
    }
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                FeedView(userService: UserService(), postService: PostService())
                    .tabItem {
                        Image(systemName: "house")
                    }
                    .tag("Home")
                NewsView()
                    .tabItem {
                        Image(systemName: "newspaper") 
                    }
                    .tag("News")
                PortfolioView()
                    .tabItem {
                        Image(systemName: "briefcase")
                    }
                    .tag("Portfolio")
                SearchView()
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
