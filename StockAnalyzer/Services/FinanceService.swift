import Foundation

class FinanceService: FinanceServiceProtocol {
    let symbol: String
    
    init(symbol: String) {
        self.symbol = symbol
    }
    
    func fetchIncomeStatement() async -> [IncomeStatement] {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/income-statement/\(symbol)?limit=11&apikey=\(ApiKeys.financeApi)") else {return []}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let incomeStatement = try? decoder.decode([IncomeStatement].self, from: data)
            
            return incomeStatement ?? []
        } catch {
            return []
        }
    }
    
    func fetchBalanceSheet() async -> [BalanceSheet] {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/balance-sheet-statement/\(symbol)?limit=11&apikey=\(ApiKeys.financeApi)") else {return []}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let balanceSheet = try? decoder.decode([BalanceSheet].self, from: data)
            
            return balanceSheet ?? []
        } catch {
            return []
        }
    }
    
    func fetchCashFlowStatement() async -> [CashFlowStatement] {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/cash-flow-statement/\(symbol)?limit=11&apikey=\(ApiKeys.financeApi)") else {return []}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let cashFlowStatement = try? decoder.decode([CashFlowStatement].self, from: data)
            
            return cashFlowStatement ?? []
        } catch {
            return []
        }
    }
    
}

class MockFinanceService: FinanceServiceProtocol {
    func fetchIncomeStatement() async -> [IncomeStatement] {
        return []
    }
    
    func fetchBalanceSheet() async -> [BalanceSheet] {
        return []
    }
    
    func fetchCashFlowStatement() async -> [CashFlowStatement] {
        return []
    }
    
    
}

protocol FinanceServiceProtocol {
    func fetchIncomeStatement() async -> [IncomeStatement]
    func fetchBalanceSheet() async -> [BalanceSheet]
    func fetchCashFlowStatement() async -> [CashFlowStatement]
}
