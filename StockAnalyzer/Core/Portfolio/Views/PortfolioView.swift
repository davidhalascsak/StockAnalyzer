import SwiftUI
import FirebaseCore
import FirebaseAuth
// current price = 110
struct PortfolioView: View {
    @State var isSettingsPresented: Bool = false
    
    @StateObject var viewModel: PortfolioViewModel
    
    init(portfolioService: PortfolioServiceProtocol, sessionService: SessionServiceProtocol) {
        _viewModel = StateObject(wrappedValue: PortfolioViewModel(portfolioService: portfolioService, sessionService: sessionService))
    }
    
    var body: some View {
        NavigationStack {
            headerView
            Divider()
            if viewModel.isLoading == false {
                if viewModel.assets.count == 0 {
                    Spacer()
                    Text(viewModel.sessionService.getUserId() == nil ? "Login to see your portfolio." : "Your portfolio is empty.")
                    Spacer()
                } else {
                    portfolioView
                    Divider()
                    HStack {
                        Spacer()
                        VStack {
                            Text(viewModel.investedAmount.formattedPrice)
                            Text("Invested")
                                .fontWeight(.semibold)
                                .padding(.top, 1)
                                
                        }
                        Spacer()
                        VStack {
                            Text(viewModel.difference.formattedPrice)
                                .foregroundColor(viewModel.difference == 0 ? Color.black : viewModel.difference > 0 ? Color.green : Color.red)
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
            viewModel.isLoading = true
            if newValue == false {
                Task {
                    await viewModel.fetchAssets()
                }
            }
        })
        .task {
            if viewModel.sessionService.getUserId() != nil {
                viewModel.isLoading = true
                await viewModel.fetchAssets()
            }
        }
    }
    
    var headerView: some View {
        HStack {
            Image(systemName: "arrow.triangle.2.circlepath")
                .font(.title2)
                .onTapGesture {
                    viewModel.isLoading = true
                    Task {
                        await viewModel.reloadPortfolio()
                    }
                }
                .disabled(viewModel.isLoading)
                .rotationEffect(Angle(degrees: viewModel.isLoading ? 360 : 0), anchor: .center)
                .opacity(viewModel.sessionService.getUserId() != nil ? 1.0 : 0.0)
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
