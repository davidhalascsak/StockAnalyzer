import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class NewAssetViewModel: ObservableObject {
    @Published var units: Double = 1.0
    @Published var buyDate: Date = Date()
    @Published var price: Double = 0.0
    @Published var value: String = ""
    
    private var db = Firestore.firestore()
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter
    }
    
    
    let symbol: String
    var portfolioService: PortfolioServiceProtocol
    var stockService: StockServiceProtocol
    
    init(symbol: String, portfolioService: PortfolioServiceProtocol, stockService: StockServiceProtocol) {
        self.symbol = symbol
        self.portfolioService = portfolioService
        self.stockService = stockService
    }
    
    func fetchPrice() async {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateAsString = formatter.string(from: buyDate)
        
        self.price = await stockService.fetchPriceAtDate(date: dateAsString)
    }
    
    func calculateValue() {
        let value = self.price * self.units
        if value == 0 {
            self.value = "$0.00"
            
        } else {
            self.value = "$\(String(format: "%.2f", value))"
        }
    }
    
    func addAssetToPortfolio() async {
        let value = price * units
        
        if value != 0 {
            let position = ["symbol": symbol, "date": formatter.string(from: self.buyDate), "units": self.units, "price": self.price,
                            "investedAmount": value] as [String : Any]
            
            if let userId = Auth.auth().currentUser?.uid {
                let portfolio = try? await db.collection("users").document(userId).collection("portfolio").document(symbol).getDocument(as: Asset.self)
                
                let newUnits = (portfolio?.units ?? 0.0) + self.units
                let newAmount = (portfolio?.investedAmount ?? 0.0) + (self.units * self.price)
                let newAveragePrice = newAmount / newUnits
                
                let newPortfolio = ["symbol": symbol, "units": newUnits, "averagePrice": newAveragePrice, "investedAmount": newAmount] as [String : Any]
                
                do {
                    try await self.db.collection("users").document(userId).collection("portfolio").document(symbol).setData(newPortfolio)
                    let _ = try await self.db.collection("users").document(userId).collection("portfolio").document(symbol).collection("positions").addDocument(data: position)
                } catch let error {
                    print(error.localizedDescription)
                }
            } else {
                //TODO: store data locally
            }
        }
    }
}
