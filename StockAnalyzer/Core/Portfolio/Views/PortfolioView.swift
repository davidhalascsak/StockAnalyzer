import SwiftUI
import FirebaseCore
import FirebaseAuth

struct PortfolioView: View {
    @StateObject var vm: PortfolioViewModel
    @State var isSettingsPresented: Bool = false
    
    init(portfolioService: PortfolioServiceProtocol) {
        _vm = StateObject(wrappedValue: PortfolioViewModel(portfolioService: portfolioService))
    }
    
    var body: some View {
        VStack {
            headerView
            Divider()
            if(vm.isLoading == false) {
                portfolioView
            } else {
                Spacer()
                ProgressView()
                Spacer()
            }
        }
        .fullScreenCover(isPresented: $isSettingsPresented, content: {
            SettingsView(userService: UserService())
        })
        .task {
            vm.isLoading = true
            await vm.fetchAssets()
        }
    }
    
    var headerView: some View {
        HStack {
            Image(systemName: "arrow.triangle.2.circlepath")
                .font(.title2)
                .opacity(0)
            Spacer()
            Text("Portfolio")
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
    
    var portfolioView: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 20) {
                Text("Assets")
                Spacer()
                Text("Units")
                Spacer()
                Text("Avg. Open")
                Spacer()
                Text("Value")
            }
            .padding(.horizontal)
            Divider()
            List {
                ForEach(vm.assets, id: \.self) { asset in
                    PortfolioRowView(asset: asset)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                }
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .listRowInsets(EdgeInsets())
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView(portfolioService: PortfolioService())
    }
}
