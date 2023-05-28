import Foundation

@MainActor
class PositionRowViewModel: ObservableObject {
    @Published var stockPrice: CurrentPrice?
    @Published var difference: Double = 0.0
    @Published var currentValue: Double = 0.0
    @Published var isLoading: Bool = true
    
    let position: Position
    let stockService: StockServiceProtocol
    
    init(position: Position, stockService: StockServiceProtocol) {
        self.position = position
        self.stockService = stockService
    }
    
    func calculateCurrentValue() async {
        let newStockPrice = await stockService.fetchPriceInRealTime()
        if let newStockPrice = newStockPrice {
            stockPrice = newStockPrice
        }

        let multiplier = (stockPrice?.price ?? 0.0) / position.price
        currentValue = multiplier * position.investedAmount
        difference = currentValue - position.investedAmount
        
        isLoading = false
    }
}
