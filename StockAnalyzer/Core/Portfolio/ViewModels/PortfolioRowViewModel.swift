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
        stockPrice = await stockService.fetchPriceInRealTime()
        
        currentValue = 0.0
        if let assets = asset.positions {
            for position in assets {
                let multiplier = (stockPrice?.price ?? 0.0) / position.price
                currentValue += multiplier * position.investedAmount
            }
        }
        difference = currentValue - asset.investedAmount
        
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

