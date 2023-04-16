import Foundation

@MainActor
class PortfolioRowViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    
    let asset: Asset
    var stockService: StockServiceProtocol
    var stockPrice: Price?
    var difference: Double = 0.0
    var currentValue: Double = 0.0
    
    init(asset: Asset, stockService: StockServiceProtocol) {
        self.asset = asset
        self.stockService = stockService
    }
    
    func fetchPrice() async {
        self.stockPrice = await stockService.fetchPriceInRealTime()
    }
    
    func calculateCurrentValue() {
        var currentValue: Double = 0.0
        
        if let assets = self.asset.positions {
            for position in assets {
                let multiplier = (self.stockPrice?.price ?? 0.0) / position.price
                currentValue += multiplier * position.units * position.price
            }
        }
        
        self.currentValue = currentValue
        self.difference = currentValue - self.asset.investedAmount
    }
    
    func updatePrice() async {
        await fetchPrice()
        calculateCurrentValue()
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

