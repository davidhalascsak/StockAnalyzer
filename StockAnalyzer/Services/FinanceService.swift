import Foundation

class FinanceService: FinanceServiceProtocol {
    let stockSymbol: String
    
    init(stockSymbol: String) {
        self.stockSymbol = stockSymbol
    }
    
    func fetchIncomeStatement() async -> [IncomeStatement] {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/income-statement/\(stockSymbol)?limit=5&apikey=\(ApiKeys.financeApi)") else {return []}
        
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
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/balance-sheet-statement/\(stockSymbol)?limit=5&apikey=\(ApiKeys.financeApi)") else {return []}
        
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
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/cash-flow-statement/\(stockSymbol)?limit=5&apikey=\(ApiKeys.financeApi)") else {return []}
        
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
    let db = MockDatabase()
    
    func fetchIncomeStatement() async -> [IncomeStatement] {
        return db.incomeStatement
    }
    
    func fetchBalanceSheet() async -> [BalanceSheet] {
        return db.balanceSheet
    }
    
    func fetchCashFlowStatement() async -> [CashFlowStatement] {
        return db.cashFlowStatement
    }
}

protocol FinanceServiceProtocol {
    func fetchIncomeStatement() async -> [IncomeStatement]
    func fetchBalanceSheet() async -> [BalanceSheet]
    func fetchCashFlowStatement() async -> [CashFlowStatement]
}

