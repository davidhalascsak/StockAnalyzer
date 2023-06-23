import SwiftUI
import FirebaseCore
import FirebaseAuth

struct PortfolioView: View {
    @State var isSettingsPresented: Bool = false
    
    @StateObject var viewModel: PortfolioViewModel
    
    init(portfolioService: PortfolioServiceProtocol, sessionService: SessionServiceProtocol) {
        _viewModel = StateObject(wrappedValue: PortfolioViewModel(portfolioService: portfolioService, sessionService: sessionService))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                headerView
                    .padding(.bottom, 5)
                Divider()
                    .padding(.bottom, 5)
                if viewModel.isLoading == false {
                    if viewModel.sessionService.getUserId() == nil {
                        Spacer()
                        Text("Login to see your portfolio.")
                        Spacer()
                    } else {
                        if viewModel.assets.count == 0 {
                            Spacer()
                            Text("Your portfolio is empty.")
                            Spacer()
                        } else {
                            portfolioView
                            Divider()
                                .padding(.bottom, 5)
                            HStack {
                                Text("Invested: ")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .padding(.top, 1)
                                Text(viewModel.investedAmount.formattedPrice)
                                    .font(.headline)
                                Spacer()
                                Text("P / L: ")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .padding(.top, 1)
                                Text(viewModel.difference.formattedPrice)
                                    .font(.headline)
                                    .foregroundColor(viewModel.difference == 0 ? Color.black : viewModel.difference > 0 ? Color.green : Color.red)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                        }
                    }
                } else {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                Divider()
                    .padding(.vertical, 5)
            }
        }
        .fullScreenCover(isPresented: $isSettingsPresented, content: {
            SettingsView(userService: UserService(), sessionService: SessionService(), imageService: ImageService())
        })
        .onChange(of: isSettingsPresented, perform: { newValue in
            viewModel.isLoading = true
            if newValue == false {
                Task {
                    await viewModel.fetchAssets()
                }
            }
        })
        .task {
            await viewModel.fetchAssets()
        }
        .onDisappear {
            viewModel.isLoading = true
        }
    }
    
    var headerView: some View {
        HStack {
            Image(systemName: "arrow.triangle.2.circlepath")
                .font(.title2)
                .onTapGesture {
                    Task {
                        await viewModel.reloadPortfolio()
                    }
                }
                .disabled(viewModel.isLoading)
                .opacity(viewModel.sessionService.getUserId() != nil && viewModel.assets.count > 0 ? 1.0 : 0.0)
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
        VStack {
            HStack {
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
                ForEach(viewModel.assets, id: \.self) { asset in
                    if let viewModel = viewModel.assetsViewModels[asset.stockSymbol] {
                        ZStack {
                            PortfolioRowView(viewModel: viewModel)
                            NavigationLink {
                                PositionView(asset: asset, stockService: StockService(stockSymbol: asset.stockSymbol), portfolioService: PortfolioService(), imageService: ImageService())
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
                .onDelete { indexSet in
                    Task {
                        viewModel.isLoading = true
                        await viewModel.deleteAsset(at: indexSet)
                    }
                }
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .padding(.top, -8)
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static let user = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
    static var previews: some View {
        PortfolioView(portfolioService: MockPortfolioService(), sessionService: MockSessionService(currentUser: user))
    }
}
