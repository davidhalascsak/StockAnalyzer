import SwiftUI
import FirebaseCore
import FirebaseAuth

struct SearchView: View {
    @State var isSettingsPresented: Bool = false
    
    @StateObject var vm: SearchViewModel
    
    
    init(searchService: SearchServiceProtocol) {
        _vm = StateObject(wrappedValue: SearchViewModel(searchService: searchService))
        UITabBar.appearance().isTranslucent = false
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                headerView
                searchBarView
                Divider()
                resultView
                Spacer()
                Divider()
                    .padding(.bottom, 5)
            }
            .fullScreenCover(isPresented: $isSettingsPresented, content: {
                SettingsView(userService: UserService(), sessionService: SessionService(), imageService: ImageService())
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
            .onDisappear {
                vm.searchText = ""
                vm.searchResult = []
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
    
    var searchBarView: some View {
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
                            vm.resetSearch()
                        }
                    }
            }
        })
    }
    
    var resultView: some View {
        List {
            ForEach(vm.searchResult, id: \.self) { elem in
                ZStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(elem.stockSymbol)
                                .font(.headline)
                            Text(elem.name)
                                .font(.subheadline)
                        }
                        Spacer()
                        Text(elem.exchangeShortName)
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    NavigationLink(destination: StockView(stockSymbol: elem.stockSymbol, stockService: StockService(stockSymbol: elem.stockSymbol), sessionService: SessionService())) {
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
        SearchView(searchService: MockSearchService())
    }
}
