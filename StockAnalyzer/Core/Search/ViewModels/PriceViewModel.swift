import Foundation

@MainActor
class PriceViewModel: ObservableObject {
    @Published var stockPrice: Price?
    @Published var timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    let symbol: String
    let currency: String
    let stockService: StockServiceProtocol
    
    init(symbol: String, currency: String, stockService: StockServiceProtocol) {
        self.symbol = symbol
        self.currency = currency
        self.stockService = stockService
    }
    
    func fetchData() async {
        self.stockPrice = await self.stockService.fetchPriceInRealTime()
    }
}
