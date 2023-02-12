import SwiftUI
import FirebaseCore
import FirebaseAuth

struct MainView: View {
    @EnvironmentObject private var vm: MainViewModel
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
                SettingsView()
            })
            .sync($vm.isSettingsPresented, with: $isSettingsPresented)
            .navigationBarBackButtonHidden()
            .navigationTitle(Text("\(selectedTab)"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "person.crop.circle")
                        .onTapGesture {
                            vm.isSettingsPresented.toggle()
                        }
                }
                
            }
        }
        
    }
}

struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(MainViewModel(email: "david.halascsak@gmail.com"))
    }
}

extension View {
    func sync(_ published: Binding<Bool>, with binding: Binding<Bool>) -> some View {
        self
            .onChange(of: published.wrappedValue) { published in
                binding.wrappedValue = published
            }
            .onChange(of: binding.wrappedValue) { binding in
                published.wrappedValue = binding
            }
    }
}
