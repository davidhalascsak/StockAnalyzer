import Foundation

class PositionRowViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    
    let position: Position
    let stockService: StockServiceProtocol
    
    var stockPrice: Double = 0.0
    var difference: Double = 0.0
    var currentValue: Double = 0.0
    
    
    init(position: Position, stockService: StockServiceProtocol) {
        self.position = position
        self.stockService = stockService
    }
    
    func fetchPrice() async {
        self.stockPrice = await stockService.fetchPriceInRealTime()
    }
    
    func calculateCurrentValue() {
        let multiplier = self.stockPrice / position.price
        self.currentValue = multiplier * position.units * position.price
        self.difference = currentValue - self.position.investedAmount
    }
    
    func toString(value: Double) -> String {
        if value < 0 {
            let text = String(format: "%.2f", value)
            return "-$\(text[1..<text.count])"
        } else {
            return "$\(String(format: "%.2f", value))"
        }
    }
}
