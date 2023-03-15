import Foundation
import Combine


class StockViewModel: ObservableObject {
    @Published var companyProfile: Company?
    @Published var option: ViewOption = .home
    @Published var showPencil: Bool = false
    @Published var isNewPostPresented: Bool = false
    
    let symbol: String
    let stockService: StockService
    
    var cancellables = Set<AnyCancellable>()
    
    init(symbol: String) {
        self.symbol = symbol
        self.stockService = StockService(symbol: symbol)
        
        addSubscribers()
    }
    
    
    func addSubscribers() {
        print("fetching company data")
        self.stockService.$companyInformation
            .sink { [weak self] (companyProfile) in
                self?.companyProfile = companyProfile ?? nil
            }
            .store(in: &cancellables)
    }
    
    func decreaseInPercentage(price: Double, change: Double) -> String {
        let result = (change / price) * 100
        let addition = change >= 0 ? "+" : ""
        
        return "\(addition)\(String(format: "%.2f", result))"
    }
    
    func createDate(timestamp: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "US_POSIX")
        formatter.dateFormat = "E, d MMM y HH:mm:ss z"
        
        let date = formatter.date(from: timestamp)
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = date {
            return formatter.string(from: date)
        }
        return "unknown date"
    }
     
}

enum ViewOption {
    case home, financials, valuation, about
}
