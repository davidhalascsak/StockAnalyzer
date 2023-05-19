import Foundation

@MainActor
class StockViewModel: ObservableObject {
    @Published var companyProfile: CompanyProfile?
    @Published var option: ViewOption = .home
    @Published var showPencil: Bool = false
    @Published var isNewPostPresented: Bool = false
    
    let symbol: String
    var stockService: StockServiceProtocol
    var sessionService: SessionServiceProtocol
    
    init(symbol: String, stockService: StockServiceProtocol, sessionService: SessionServiceProtocol) {
        self.symbol = symbol
        self.stockService = stockService
        self.sessionService = sessionService
    }
    
    func fetchData() async {
        self.companyProfile = await self.stockService.fetchProfile()
    }
}

enum ViewOption {
    case home, financials, valuation, about
}
