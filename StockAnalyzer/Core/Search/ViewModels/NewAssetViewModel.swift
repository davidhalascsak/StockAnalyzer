import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class NewAssetViewModel: ObservableObject {
    @Published var units: Double = 1.0
    @Published var buyDate: Date = Date()
    @Published var price: Double = 0.0
    @Published var value: String = ""
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertText: String = ""
    
    let symbol: String
    var portfolioService: PortfolioServiceProtocol
    var stockService: StockServiceProtocol
    
    private var db = Firestore.firestore()
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter
    }
    
    init(symbol: String, portfolioService: PortfolioServiceProtocol, stockService: StockServiceProtocol) {
        self.symbol = symbol
        self.portfolioService = portfolioService
        self.stockService = stockService
    }
    
    func fetchPrice() async {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateAsString = formatter.string(from: buyDate)
        
        price = await stockService.fetchPriceAtDate(date: dateAsString)
    }
    
    func calculateValue() {
        let value = price * units
        if value <= 0 {
            self.value = "Invalid Value"
            
        } else {
            self.value = "$\(String(format: "%.2f", value))"
        }
    }
    
    func addPositionToPortfolio() async {
        let value = price * units
        
        if value > 0 {
            let position = Position(date: formatter.string(from: buyDate), units: units, price: price)
            let result = await portfolioService.addPosition(symbol: symbol, position: position)
            if result == false {
                showAlert.toggle()
                alertTitle = "Error"
                alertText = "The position cannot be added to your portfolio."
            }
        } else {
            showAlert.toggle()
            alertTitle = "Error"
            alertText = "The price is invalid."
        }
    }
}
