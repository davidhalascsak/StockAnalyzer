import Foundation

@MainActor
class PriceViewModel: ObservableObject {
    @Published var stockPrice: CurrentPrice?
    @Published var timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    let stockSymbol: String
    let currency: String
    let stockService: StockServiceProtocol
    
    init(stockSymbol: String, currency: String, stockService: StockServiceProtocol) {
        self.stockSymbol = stockSymbol
        self.currency = currency
        self.stockService = stockService
    }
    
    func fetchPrice() async {
        let newStockPrice = await stockService.fetchPriceInRealTime()
        if newStockPrice != nil {
            stockPrice = newStockPrice
        }
    }
}
