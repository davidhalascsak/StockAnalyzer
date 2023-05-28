import Foundation

@MainActor
class PortfolioViewModel: ObservableObject {
    @Published var assets: [Asset] = []
    @Published var isLoading: Bool = false
    @Published var investedAmount: Double = 0
    @Published var difference: Double = 0
    @Published var assetsViewModels: [String: PortfolioRowViewModel] = [:]

    
    var portfolioService: PortfolioServiceProtocol
    var sessionService: SessionServiceProtocol
    
    init(portfolioService: PortfolioServiceProtocol, sessionService: SessionServiceProtocol) {
        self.portfolioService = portfolioService
        self.sessionService = sessionService
    }
    
    func fetchAssets() async {
        investedAmount = 0
        difference = 0
        
        assets = await portfolioService.fetchAssets()
        for asset in assets {
            let vm = PortfolioRowViewModel(asset: asset, stockService: StockService(stockSymbol: asset.stockSymbol))
            assetsViewModels[asset.stockSymbol] = vm
            await vm.calculateCurrentValue()
            investedAmount += vm.asset.investedAmount
            difference += vm.difference
        }
        
        isLoading = false
    }
    
    func reloadPortfolio() async {
        var newInvestedAmount: Double = 0.0
        var newDifference: Double = 0.0
        for asset in assets {
            if let vm = assetsViewModels[asset.stockSymbol] {
                await vm.calculateCurrentValue()
                newInvestedAmount += vm.asset.investedAmount
                newDifference += vm.difference
            }
        }
        investedAmount = newInvestedAmount
        difference = newDifference
        isLoading = false
    }
    
    func deleteAsset(at offsets: IndexSet) async {
        let index = offsets.first ?? nil
        if let index = index {
            let assetSymbol = assets[index].stockSymbol
            
            let result = await portfolioService.deleteAsset(stockSymbol: assetSymbol)
            if result == true {
                assets.remove(at: index)
                assetsViewModels.removeValue(forKey: assetSymbol)
                await reloadPortfolio()
            }
        }
    }
}
