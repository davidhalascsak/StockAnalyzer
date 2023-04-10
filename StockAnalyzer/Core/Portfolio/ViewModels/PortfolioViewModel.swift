import Foundation

@MainActor
class PortfolioViewModel: ObservableObject {
    @Published var assets: [Asset] = []
    @Published var isLoading: Bool = false
    var portfolioService: PortfolioServiceProtocol
    
    init(portfolioService: PortfolioServiceProtocol) {
        self.portfolioService = portfolioService
    }
    
    func fetchAssets() async {
        assets = await self.portfolioService.fetchAssets()
        self.isLoading = false
    }
    
    func deleteAsset(at index: Int) async {
        let assetSymbol = assets[index].symbol
        
        await self.portfolioService.deleteAsset(symbol: assetSymbol)
        assets.remove(at: index)
    }
}
