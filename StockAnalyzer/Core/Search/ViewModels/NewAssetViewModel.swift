import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class NewAssetViewModel: ObservableObject {
    @Published var units: Double = 1.0
    @Published var buyDate: Date = Date()
    @Published var price: Double?
    @Published var value: String = ""
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertText: String = ""
    
    let stockSymbol: String
    var portfolioService: PortfolioServiceProtocol
    var stockService: StockServiceProtocol
    
    private var db = Firestore.firestore()
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter
    }
    
    init(stockSymbol: String, portfolioService: PortfolioServiceProtocol, stockService: StockServiceProtocol) {
        self.stockSymbol = stockSymbol
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
        let value = (price ?? 0.0) * units
        if value <= 0 {
            self.value = "Invalid Value"
            
        } else {
            self.value = "$\(String(format: "%.2f", value))"
        }
    }
    
    func addPositionToPortfolio() async {
        let value = (price ?? 0.0) * units
        
        if value > 0 {
            let position = Position(date: formatter.string(from: buyDate), units: units, price: price ?? 0.0)
            let result = await portfolioService.addPosition(stockSymbol: stockSymbol, position: position)
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
