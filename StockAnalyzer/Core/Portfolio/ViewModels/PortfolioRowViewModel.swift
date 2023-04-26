import Foundation

@MainActor
class PortfolioRowViewModel: ObservableObject {
    @Published var stockPrice: Price?
    @Published var currentValue: Double = 0.0
    @Published var difference: Double = 0.0
    @Published var isLoading: Bool = true
    
    let asset: Asset
    var stockService: StockServiceProtocol
    
    init(asset: Asset, stockService: StockServiceProtocol) {
        self.asset = asset
        self.stockService = stockService
    }
    
    func calculateCurrentValue() async {
        self.stockPrice = await stockService.fetchPriceInRealTime()
        
        var currentValue: Double = 0.0
        
        if let assets = self.asset.positions {
            for position in assets {
                let multiplier = (self.stockPrice?.price ?? 0.0) / position.price
                currentValue += multiplier * position.investedAmount
            }
        }
        
        self.currentValue = currentValue
        self.difference = currentValue - self.asset.investedAmount
        
        self.isLoading = false
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

