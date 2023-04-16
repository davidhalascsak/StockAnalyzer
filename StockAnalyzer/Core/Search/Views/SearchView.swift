import SwiftUI
import FirebaseCore
import FirebaseAuth

struct SearchView: View {
    @StateObject var vm: SearchViewModel
    @State var isSettingsPresented: Bool = false
    
    init(searchService: SearchServiceProtocol) {
        _vm = StateObject(wrappedValue: SearchViewModel(searchService: searchService))
        UITabBar.appearance().isTranslucent = false
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                headerView
                searchBar
                Divider()
                if vm.searchText.count > 0 {
                    resultView
                }
                Spacer()
            }
            .fullScreenCover(isPresented: $isSettingsPresented, content: {
                SettingsView(userService: UserService(), sessionService: SessionService())
            })
            .onChange(of: vm.searchText) { _ in
                
                Task {
                    vm.searchTask?.cancel()
                    
                    let task = Task.detached {
                        try await Task.sleep(nanoseconds: 500_000_000)
                        await vm.fetchData()
                    }
                    
                    vm.searchTask = task
                }
            }
        }
    }
    
    var headerView: some View {
        HStack {
            Image(systemName: "arrow.triangle.2.circlepath")
                .font(.title2)
                .opacity(0)
            Spacer()
            Text("Search")
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
    
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .padding(.trailing, 2)
            TextField("search", text: $vm.searchText)
                .autocorrectionDisabled()
            
        }
        .padding(.horizontal, 5)
        .padding(3)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(5)
        .padding(.horizontal, 5)
        .padding(5)
        .overlay(alignment: .trailing, content: {
            if vm.searchText.count > 0 {
                Image(systemName: "x.circle")
                    .padding(.horizontal, 20)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            vm.searchText = ""
                        }
                    }
            }
        })
    }
    
    var resultView: some View {
        List {
            ForEach(vm.searchResult, id: \.self) { result in
                ZStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(result.symbol)
                                .font(.headline)
                            Text(result.name)
                                .font(.subheadline)
                        }
                        Spacer()
                        Text(result.exchangeShortName)
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    NavigationLink(destination: StockView(symbol: result.symbol, stockService: StockService(symbol: result.symbol), sessionService: SessionService())) {
                        EmptyView()
                    }
                    .opacity(0)
                }
                .alignmentGuide(.listRowSeparatorLeading) { dimension in
                    dimension[.leading]
                }
                .listRowInsets(EdgeInsets())
            }
        }
        .padding(.top, -8)
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(searchService: SearchService())
    }
}
