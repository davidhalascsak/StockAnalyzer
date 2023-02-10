import SwiftUI
import FirebaseCore
import FirebaseAuth

struct MainView: View {
    @EnvironmentObject private var vm: MainViewModel
    @State var isSettingsPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            TabView {
                DashboardView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                NewsView()
                    .tabItem {
                        Label("News", systemImage: "newspaper")
                    }
                PortfolioView()
                    .tabItem {
                        Label("Portfolio", systemImage: "briefcase")
                    }
                SearchView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
            }
            .fullScreenCover(isPresented: $isSettingsPresented, content: {
                SettingsView()
            })
            .sync($vm.isSettingsPresented, with: $isSettingsPresented)
            .navigationBarBackButtonHidden()
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
