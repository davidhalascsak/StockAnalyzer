import Foundation

@MainActor
class PortfolioViewModel: ObservableObject {
    @Published var assets: [Asset] = []
    @Published var isLoading: Bool = false
    @Published var assetsViewModels: [String: PortfolioRowViewModel] = [:]
    
    var portfolioService: PortfolioServiceProtocol
    var sessionService: SessionServiceProtocol
    
    init(portfolioService: PortfolioServiceProtocol, sessionService: SessionServiceProtocol) {
        self.portfolioService = portfolioService
        self.sessionService = sessionService
    }
    
    func fetchAssets() async {
        assets = await self.portfolioService.fetchAssets()
        for asset in assets {
            let vm = PortfolioRowViewModel(asset: asset, stockService: StockService(symbol: asset.symbol))
            assetsViewModels[asset.symbol] = vm
        }
        
        self.isLoading = false
    }
    
    func reloadPortfolio() async {
        for asset in assets {
            if let vm = assetsViewModels[asset.symbol] {
                await vm.updatePrice()
            }
        }
    }
    
    func deleteAsset(at index: Int) async {
        let assetSymbol = assets[index].symbol
        
        await self.portfolioService.deleteAsset(symbol: assetSymbol)
        assets.remove(at: index)
    }
}
