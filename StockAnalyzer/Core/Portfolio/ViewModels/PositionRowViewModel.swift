import Foundation

@MainActor
class PositionRowViewModel: ObservableObject {
    @Published var stockPrice: Price?
    @Published var difference: Double = 0.0
    @Published var currentValue: Double = 0.0
    @Published var isLoading: Bool = false
    
    let position: Position
    let stockService: StockServiceProtocol
    
    init(position: Position, stockService: StockServiceProtocol) {
        self.position = position
        self.stockService = stockService
    }
    
    func calculateCurrentValue() async {
        stockPrice = await stockService.fetchPriceInRealTime()
        
        let multiplier = (stockPrice?.price ?? 0.0) / position.price
        currentValue = multiplier * position.investedAmount
        difference = currentValue - position.investedAmount
        
        isLoading = false
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
