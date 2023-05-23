import Foundation

@MainActor
class StockViewModel: ObservableObject {
    @Published var companyProfile: CompanyProfile?
    @Published var option: MenuOptions = .home
    @Published var showPencil: Bool = false
    
    let stockSymbol: String
    var stockService: StockServiceProtocol
    var sessionService: SessionServiceProtocol
    
    init(stockSymbol: String, stockService: StockServiceProtocol, sessionService: SessionServiceProtocol) {
        self.stockSymbol = stockSymbol
        self.stockService = stockService
        self.sessionService = sessionService
    }
    
    func fetchData() async {
        self.companyProfile = await self.stockService.fetchProfile()
    }
    
    enum MenuOptions {
        case home, financials, valuation, about
    }
}


