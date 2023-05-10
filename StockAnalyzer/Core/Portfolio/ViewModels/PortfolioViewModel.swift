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
        assets = await portfolioService.fetchAssets()
        for asset in assets {
            let vm = PortfolioRowViewModel(asset: asset, stockService: StockService(symbol: asset.symbol))
            assetsViewModels[asset.symbol] = vm
            await vm.calculateCurrentValue()
            investedAmount += vm.asset.investedAmount
            difference += vm.difference
        }
        
        isLoading = false
    }
    
    func reloadPortfolio() async {
        var newInvestedAmount = 0.0
        var newDifference = 0.0
        for asset in assets {
            if let vm = assetsViewModels[asset.symbol] {
                await vm.calculateCurrentValue()
                newInvestedAmount += vm.asset.investedAmount
                newDifference += vm.difference
            }
        }
        investedAmount = newInvestedAmount
        difference = newDifference
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
    
    func formatValue(value: Double) -> String {
        if value < 0 {
            let text = String(format: "%.2f", value)
            return "-$\(text[1..<text.count])"
        } else {
            return "$\(String(format: "%.2f", value))"
        }
    }
}
