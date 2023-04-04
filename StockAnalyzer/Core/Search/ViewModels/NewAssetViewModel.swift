import Foundation

class NewAssetViewModel: ObservableObject {
    @Published var units: String = "1.0"
    @Published var buyDate: Date = Date()
    @Published var price: String = "120.0"
    
    let symbol: String
    var portfolioService: PortfolioServiceProtocol
    var stockService: StockServiceProtocol
    
    init(symbol: String, portfolioService: PortfolioServiceProtocol, stockService: StockServiceProtocol) {
        self.symbol = symbol
        self.portfolioService = portfolioService
        self.stockService = stockService
    }
}
