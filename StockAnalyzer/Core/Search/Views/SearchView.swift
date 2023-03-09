import SwiftUI
import FirebaseCore
import FirebaseAuth

struct SearchView: View {
    @StateObject var vm = SearchViewModel()
    @State var isSettingsPresented: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                headerView
                TextField("search", text: $vm.searchText)
                    .autocorrectionDisabled()
                    .padding(.horizontal, 5)
                    .padding(3)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding()
                    .overlay(alignment: .trailing, content: {
                        if vm.searchText.count > 0 {
                            Image(systemName: "x.circle")
                                .padding(.horizontal, 25)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        vm.searchText = ""
                                    }
                                }
                        }
                    })
                if vm.searchText.count > 0 {
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
                                NavigationLink(destination: StockView(symbol: result.symbol)) {
                                    EmptyView()
                                }
                                .opacity(0)
                            }
                            
                        }
                    }
                    .listStyle(.plain)
                }
                Spacer()
            }
            .fullScreenCover(isPresented: $isSettingsPresented, content: {
                SettingsView()
            })
        }
    }
    
    var headerView: some View {
        HStack() {
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
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
