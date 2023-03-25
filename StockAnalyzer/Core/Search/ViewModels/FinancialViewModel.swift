import Foundation
import Combine

class FinancialViewModel: ObservableObject {
    @Published var incomeStatement: [IncomeStatement] = []
    @Published var balanceSheet: [BalanceSheet] = []
    @Published var cashFlowStatement: [CashFlowStatement] = []
    @Published var isLoading: Bool = false
    @Published var loadCounter: Int = 0
    
    let company: Company
    
    init(company: Company) {
        self.company = company
        self.isLoading = true
        addListeners()
    }
    
    var cancellables = Set<AnyCancellable>()
    
    func addListeners() {
        fetchIncome()
        fetchBalance()
        fetchCashFlow()
    }
    
    func fetchIncome() {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/income-statement/\(company.symbol)?limit=10&apikey=\(ApiKeys.financeApi)") else {return}
        
        NetworkingManager.download(url: url)
            .decode(type: [IncomeStatement].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] incomeStatement in
                self?.incomeStatement = incomeStatement
                self?.loadCounter += 1
                if self?.loadCounter == 3 {
                    self?.isLoading = false
                    self?.loadCounter = 0
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchBalance() {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/balance-sheet-statement/\(company.symbol)?limit=10&apikey=\(ApiKeys.financeApi)") else {return}
        
        NetworkingManager.download(url: url)
            .decode(type: [BalanceSheet].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] balanceSheet in
                self?.balanceSheet = balanceSheet
                self?.loadCounter += 1
                if self?.loadCounter == 3 {
                    self?.isLoading = false
                    self?.loadCounter = 0
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchCashFlow() {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/cash-flow-statement/\(company.symbol)?limit=10&apikey=\(ApiKeys.financeApi)") else {return}
        
        NetworkingManager.download(url: url)
            .decode(type: [CashFlowStatement].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] cashFlow in
                self?.cashFlowStatement = cashFlow
                self?.loadCounter += 1
                if self?.loadCounter == 3 {
                    self?.isLoading = false
                    self?.loadCounter = 0
                }
            }
            .store(in: &cancellables)
    }
    
    func calculateROE() -> String {
        let taxRate =  Double(self.incomeStatement[0].incomeTaxExpense) / Double(self.incomeStatement[0].incomeBeforeTax)
        let nopat = Double(self.incomeStatement[0].operatingIncome) * (1.0 - taxRate)
        
        let roe = nopat / Double(self.balanceSheet[0].totalAssets - self.balanceSheet[0].totalLiabilities)
        return String(format: "%.0f", 100 * roe)
    }
    
    func calculateROA() -> String {
        let taxRate =  Double(self.incomeStatement[0].incomeTaxExpense) / Double(self.incomeStatement[0].incomeBeforeTax)
        let nopat = Double(self.incomeStatement[0].operatingIncome) * (1.0 - taxRate)
        
        let roa = nopat / Double(self.balanceSheet[0].totalAssets)
        return String(format: "%.0f", 100 * roa)
    }
    
    func calculateROIC() -> String {
        let taxRate =  Double(self.incomeStatement[0].incomeTaxExpense) / Double(self.incomeStatement[0].incomeBeforeTax)
        let nopat = Double(self.incomeStatement[0].operatingIncome) * (1.0 - taxRate)
        
        let helper = self.balanceSheet[0].totalCurrentLiabilities - self.balanceSheet[0].totalCurrentAssets + self.balanceSheet[0].cashAndCashEquivalents
        let investedCapital = self.balanceSheet[0].totalAssets - self.balanceSheet[0].accountPayables - (self.balanceSheet[0].cashAndCashEquivalents - max(0, helper))
        
        let roic = nopat / Double(investedCapital)
        
        return String(format: "%.0f", 100 * roic)
    }
    
    func calculateROCE() -> String {
        let roce = Double(self.incomeStatement[0].incomeBeforeTax) / Double(self.balanceSheet[0].totalAssets - self.balanceSheet[0].totalCurrentLiabilities)
        return String(format: "%.0f", 100 * roce)
    }
    
    func calculateGrowthRates(data: [Int]) -> [Double] {
        
        let oneYear: Double = Double(data[data.count - 1] - data[data.count - 2] / data[data.count - 1])
        let threeYear: Double = Double(data[data.count - 1] - data[data.count - 4] / data[data.count - 1])
        let fiveYear: Double = Double(data[data.count - 1] - data[data.count - 6] / data[data.count - 1])
        let tenYear: Double = Double(data[data.count - 1] - data[data.count - 10] / data[data.count - 1])
        
        return [oneYear, threeYear, fiveYear, tenYear]
    }
}
