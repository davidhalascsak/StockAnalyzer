import SwiftUI
import FirebaseCore
import FirebaseAuth

struct MainView: View {
    @State var isSettingsPresented: Bool = false
    @State var selectedTab: String = "Home"
    
    init() {
        UITabBar.appearance().isTranslucent = false
        UINavigationBar.appearance().isTranslucent = false
    }
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                FeedView()
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
            
            .fullScreenCover(isPresented: $isSettingsPresented, content: {
                SettingsView(isSettingsPresented: $isSettingsPresented)
            })
            .navigationBarBackButtonHidden()
            .navigationTitle(Text("\(selectedTab)"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "person.crop.circle")
                        .onTapGesture {
                            self.isSettingsPresented.toggle()
                        }
                }
                
            }
        }
        
    }
}

struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
