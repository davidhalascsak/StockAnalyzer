import SwiftUI
import FirebaseCore
import FirebaseAuth

struct PortfolioView: View {
    @StateObject var vm: PortfolioViewModel
    @State var isSettingsPresented: Bool = false
    
    init(portfolioService: PortfolioServiceProtocol, sessionService: SessionServiceProtocol) {
        _vm = StateObject(wrappedValue: PortfolioViewModel(portfolioService: portfolioService, sessionService: sessionService))
    }
    
    var body: some View {
        NavigationStack {
            headerView
            Divider()
            if vm.isLoading == false {
                if vm.assets.count == 0 {
                    Spacer()
                    Text(vm.sessionService.getUserId() == nil ? "Login to see your portfolio." : "Your portfolio is empty.")
                    Spacer()
                } else {
                    portfolio
                    Divider()
                    HStack {
                        Spacer()
                        VStack {
                            Text(vm.formatValue(value: vm.investedAmount))
                            Text("Invested")
                                .fontWeight(.semibold)
                                .padding(.top, 1)
                                
                        }
                        Spacer()
                        VStack {
                            Text(vm.formatValue(value: vm.difference))
                                .foregroundColor(vm.difference == 0 ? Color.black : vm.difference > 0 ? Color.green : Color.red)
                            Text("P / L")
                                .fontWeight(.semibold)
                                .padding(.top, 1)
                                
                        }
                        Spacer()
                    }
                }
            } else {
                Spacer()
                ProgressView()
                Spacer()
            }
        }
        .fullScreenCover(isPresented: $isSettingsPresented, content: {
            SettingsView(userService: UserService(), sessionService: SessionService(), imageService: ImageService())
        })
        .onChange(of: isSettingsPresented, perform: { newValue in
            if newValue == false {
                Task {
                    await vm.fetchAssets()
                }
            }
        })
        .task {
            if vm.sessionService.getUserId() != nil {
                vm.isLoading = true
                await vm.fetchAssets()
            }
        }
    }
    
    var headerView: some View {
        HStack {
            Image(systemName: "arrow.triangle.2.circlepath")
                .font(.title2)
                .onTapGesture {
                    vm.isLoading = true
                    Task {
                        await vm.reloadPortfolio()
                    }
                }
                .disabled(vm.isLoading)
                .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)
                .opacity(vm.sessionService.getUserId() != nil ? 1.0 : 0.0)
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
    
    var portfolio: some View {
        VStack {
            HStack(spacing: 20) {
                Text("Assets")
                Spacer()
                Text("Invested")
                Spacer()
                Text("P / L")
                Spacer()
                Text("Value")
            }
            .padding(.horizontal)
            Divider()
            List {
                ForEach(vm.assets, id: \.self) { asset in
                    if let viewModel = vm.assetsViewModels[asset.symbol] {
                        ZStack {
                            PortfolioRowView(viewModel: viewModel)
                            NavigationLink {
                                PositionView(asset: asset, stockService: StockService(symbol: asset.symbol), portfolioService: PortfolioService(), imageService: ImageService())
                            } label: {
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
                .onDelete(perform: delete)
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .padding(.top, -8)
        }
    }
    
    func delete(at offsets: IndexSet) {
        let index = offsets.first ?? nil
        if let index = index {
            Task {
                await vm.deleteAsset(at: index)
            }
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static let user = AuthUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
    static var previews: some View {
        PortfolioView(portfolioService: MockPortfolioService(), sessionService: MockSessionService(currentUser: user))
    }
}
