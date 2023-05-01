import Foundation

@MainActor
class PortfolioViewModel: ObservableObject {
    @Published var assets: [Asset] = []
    @Published var isLoading: Bool = true
    @Published var assetsViewModels: [String: PortfolioRowViewModel] = [:]
    
    var portfolioService: PortfolioServiceProtocol
    var sessionService: SessionServiceProtocol
    
    init(portfolioService: PortfolioServiceProtocol, sessionService: SessionServiceProtocol) {
        self.portfolioService = portfolioService
        self.sessionService = sessionService
    }
    
    func fetchAssets() async {
        assets = await portfolioService.fetchAssets()
        for asset in assets {
            let vm = PortfolioRowViewModel(asset: asset, stockService: StockService(symbol: asset.symbol))
            assetsViewModels[asset.symbol] = vm
            await vm.calculateCurrentValue()
        }
        
        isLoading = false
    }
    
    func reloadPortfolio() async {
        for asset in assets {
            if let vm = assetsViewModels[asset.symbol] {
                await vm.calculateCurrentValue()
            }
        }
        isLoading = false
    }
    
    func deleteAsset(at index: Int) async {
        let assetSymbol = assets[index].symbol
        
        let result = await portfolioService.deleteAsset(symbol: assetSymbol)
        if result == true {
            assets.remove(at: index)
            assetsViewModels.removeValue(forKey: assetSymbol)
        }
        
    }
}
