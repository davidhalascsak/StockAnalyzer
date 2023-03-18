import Foundation
import Combine

class FinancialViewModel: ObservableObject {
    @Published var ratios: Ratios?
    @Published var marketCap: MarketCap?
    @Published var incomeStatement: [IncomeStatement] = []
    @Published var balanceSheet: [BalanceSheet] = []
    @Published var cashFlowStatement: [CashFlowStatement] = []
    
    let company: Company
    
    init(company: Company) {
        self.company = company
        addListeners()
    }
    
    var cancellables = Set<AnyCancellable>()
    
    func addListeners() {
        fetchRatios()
        fetchMarketCap()
        fetchIncome()
        fetchBalance()
        fetchCashFlow()
    }
    
    func fetchMarketCap() {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/market-capitalization/\(company.symbol)?apikey=\(ApiKeys.financeApi)") else {return}
                
        NetworkingManager.download(url: url)
            .decode(type: [MarketCap].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] enterpriseValue in
                self?.marketCap = enterpriseValue[0]
            }
            .store(in: &cancellables)
    }
    
    func fetchRatios() {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/ratios-ttm/\(company.symbol)?apikey=\(ApiKeys.financeApi)") else {return}
                
        NetworkingManager.download(url: url)
            .decode(type: [Ratios].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] metrics in
                self?.ratios = metrics[0]
            }
            .store(in: &cancellables)
    }
    
    func fetchIncome() {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/income-statement/\(company.symbol)?limit=5&apikey=\(ApiKeys.financeApi)") else {return}
        
        NetworkingManager.download(url: url)
            .decode(type: [IncomeStatement].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] income in
                self?.incomeStatement = income
            }
            .store(in: &cancellables)
    }
    
    func fetchBalance() {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/balance-sheet-statement/\(company.symbol)?limit=5&apikey=\(ApiKeys.financeApi)") else {return}
        
        NetworkingManager.download(url: url)
            .decode(type: [BalanceSheet].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] balance in
                self?.balanceSheet = balance
            }
            .store(in: &cancellables)
    }
    
    func fetchCashFlow() {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/cash-flow-statement/\(company.symbol)?limit=5&apikey=\(ApiKeys.financeApi)") else {return}
        
        NetworkingManager.download(url: url)
            .decode(type: [CashFlowStatement].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] cashFLow in
                self?.cashFlowStatement = cashFLow
            }
            .store(in: &cancellables)
    }
    
    func formatPrice(price: Int) -> String {
        let priceAsString: String = String(price)
        var result: String
        
        if priceAsString.count % 3 == 0 {
            result = "\(priceAsString[0...2]).\(priceAsString[3...5])"
        } else if priceAsString.count % 3 == 1 {
            result = "\(priceAsString[0]).\(priceAsString[1...3])"
        } else {
            result = "\(priceAsString[0...1]).\(priceAsString[2...4])"
        }
        
        if priceAsString.count < 10 {
            result.append("M")
        } else if 10 <= priceAsString.count && priceAsString.count < 13 {
            result.append("B")
        } else {
            result.append("T")
        }
        
        return result
    }
}

struct Ratios: Decodable {
    let dividendPerShareTTM: Double
    let dividendYielPercentageTTM: Double
    let peRatioTTM: Double
    let pegRatioTTM: Double
    let priceToSalesRatioTTM: Double
    let priceToBookRatioTTM: Double
}

struct IncomeStatement: Decodable {
    
}

struct BalanceSheet: Decodable {
    
}

struct CashFlowStatement: Decodable {
    
}

struct MarketCap: Decodable {
    let marketCap: Int
}
