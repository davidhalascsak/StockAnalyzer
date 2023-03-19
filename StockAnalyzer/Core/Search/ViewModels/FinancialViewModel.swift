import Foundation
import Combine

class FinancialViewModel: ObservableObject {
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
        fetchIncome()
        fetchBalance()
        fetchCashFlow()
    }
    
    func fetchIncome() {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/income-statement/\(company.symbol)?limit=5&apikey=\(ApiKeys.financeApi)") else {return}
        
        NetworkingManager.download(url: url)
            .decode(type: [IncomeStatement].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] incomeStatement in
                self?.incomeStatement = incomeStatement
            }
            .store(in: &cancellables)
    }
    
    func fetchBalance() {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/balance-sheet-statement/\(company.symbol)?limit=5&apikey=\(ApiKeys.financeApi)") else {return}
        
        NetworkingManager.download(url: url)
            .decode(type: [BalanceSheet].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] balanceSheet in
                self?.balanceSheet = balanceSheet
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
    
    
    
    func calculateROIC() -> String {
        return "20.20%"
    }
}


struct IncomeStatement: Decodable {
    let date: String
    let reportedCurrency: String
    let revenue: Int
    let grossProfit: Int
    let operatingIncome: Int
    let incomeBeforeTax: Int
    let incomeTaxExpense: Int
    let netIncome: Int
    let weightedAverageShsOut: Int
}

// Total Assets    -    Accounts Payable & Accrued Expense    -    ( Cash, Cash Equivalents, Marketable Securities    -    max(0, Total Current Liabilities    -    Total Current Assets    +    Cash, Cash Equivalents, Marketable Securities    ))

struct BalanceSheet: Decodable {
    let date: String
    let reportedCurrency: String
    
    let cashAndCashEquivalents: Int
    let shortTermInvestments: Int
    let netReceivables: Int
    let inventory: Int
    let otherCurrentAssets: Int
    let totalCurrentAssets: Int
    
    let longTermInvestments: Int
    let propertyPlantEquipmentNet: Int
    let goodwill: Int
    let intangibleAssets: Int
    let otherNonCurrentAssets: Int
    let totalNonCurrentAssets: Int
    
    let accountPayables: Int
    let shortTermDebt: Int
    let otherCurrentLiabilities: Int
    let totalCurrentLiabilities: Int
    
    let longTermDebt: Int
    let otherNonCurrentLiabilities: Int
    let totalNonCurrentLiabilities: Int
    
    let totalInvestments: Int
    let totalDebt: Int
    let netDebt: Int
}

struct CashFlowStatement: Decodable {
    let date: String
    let reportedCurrency: String
    let netIncome: Int
    let netCashProvidedByOperatingActivities: Int
    let netCashUsedForInvestingActivites: Int
    let netCashUsedProvidedByFinancingActivities: Int
    
    let stockBasedCompensation: Int
    let debtRepayment: Int
    let commonStockIssued: Int
    let commonStockRepurchased: Int
    let dividendsPaid: Int
    
    let netChangeInCash: Int
    let cashAtBeginningOfPeriod: Int
    let cashAtEndOfPeriod: Int
    
    let operatingCashFlow: Int
    let capitalExpenditure: Int
    let freeCashFlow: Int
}
