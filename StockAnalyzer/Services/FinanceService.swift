import Foundation

class FinanceService: FinanceServiceProtocol {
    let symbol: String
    
    init(symbol: String) {
        self.symbol = symbol
    }
    
    func fetchIncomeStatement() async -> [IncomeStatement] {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/income-statement/\(self.symbol)?limit=10&apikey=\(ApiKeys.financeApi)") else {return []}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let incomeStatement = try? decoder.decode([IncomeStatement].self, from: data)
            if let incomeStatement = incomeStatement {
                return incomeStatement
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return []
    }
    
    func fetchBalanceSheet() async -> [BalanceSheet] {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/balance-sheet-statement/\(self.symbol)?limit=10&apikey=\(ApiKeys.financeApi)") else {return []}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let balanceSheet = try? decoder.decode([BalanceSheet].self, from: data)
            if let balanceSheet = balanceSheet {
                return balanceSheet
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return []
    }
    
    func fetchCashFlowStatement() async -> [CashFlowStatement] {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/cash-flow-statement/\(self.symbol)?limit=10&apikey=\(ApiKeys.financeApi)") else {return []}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let cashFlowStatement = try? decoder.decode([CashFlowStatement].self, from: data)
            if let cashFlowStatement = cashFlowStatement {
                return cashFlowStatement
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return []
    }
    
}

protocol FinanceServiceProtocol {
    func fetchIncomeStatement() async -> [IncomeStatement]
    func fetchBalanceSheet() async -> [BalanceSheet]
    func fetchCashFlowStatement() async -> [CashFlowStatement]
}
