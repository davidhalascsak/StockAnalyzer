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
}

struct Asset: Hashable, Codable {
    let symbol: String
    let units: Double
    let averagePrice: Double
    let currentValue: Double
}
