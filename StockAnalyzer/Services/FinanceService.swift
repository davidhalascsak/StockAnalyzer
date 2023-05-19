import Foundation

class FinanceService: FinanceServiceProtocol {
    let symbol: String
    
    init(symbol: String) {
        self.symbol = symbol
    }
    
    func fetchIncomeStatement() async -> [IncomeStatement] {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/income-statement/\(symbol)?limit=5&apikey=\(ApiKeys.financeApi)") else {return []}
        
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
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/balance-sheet-statement/\(symbol)?limit=5&apikey=\(ApiKeys.financeApi)") else {return []}
        
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
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/cash-flow-statement/\(symbol)?limit=5&apikey=\(ApiKeys.financeApi)") else {return []}
        
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
        return [
            IncomeStatement(date: "2022-09-24", reportedCurrency: "USD", revenue: 394328000000, grossProfit: 170782000000, operatingIncome: 119437000000, incomeBeforeTax: 119103000000, incomeTaxExpense: 19300000000, netIncome: 99803000000, weightedAverageShsOut: 16215963000),
                IncomeStatement(date: "2021-09-25", reportedCurrency: "USD", revenue: 365817000000, grossProfit: 152836000000, operatingIncome: 108949000000, incomeBeforeTax: 109207000000, incomeTaxExpense: 14527000000, netIncome: 94680000000, weightedAverageShsOut: 16701272000),
                IncomeStatement(date: "2020-09-26", reportedCurrency: "USD", revenue: 274515000000, grossProfit: 104956000000, operatingIncome: 66288000000, incomeBeforeTax: 67091000000, incomeTaxExpense: 9680000000, netIncome: 57411000000, weightedAverageShsOut: 17352119000),
                IncomeStatement(date: "2019-09-28", reportedCurrency: "USD", revenue: 260174000000, grossProfit: 98392000000, operatingIncome: 63930000000, incomeBeforeTax: 65737000000, incomeTaxExpense: 10481000000, netIncome: 55256000000, weightedAverageShsOut: 18471336000),
                IncomeStatement(date: "2018-09-29", reportedCurrency: "USD", revenue: 265595000000, grossProfit: 101839000000, operatingIncome: 70898000000, incomeBeforeTax: 72903000000, incomeTaxExpense: 13372000000, netIncome: 59531000000, weightedAverageShsOut: 19821508000)
        ]
    }
    
    func fetchBalanceSheet() async -> [BalanceSheet] {
        return [
            BalanceSheet(date: "2022-09-24", reportedCurrency: "USD", totalCurrentAssets: 135405000000, totalNonCurrentAssets: 217350000000, shortTermDebt: 21110000000, totalCurrentLiabilities: 153982000000, longTermDebt: 98959000000,  totalNonCurrentLiabilities: 148101000000, netDebt: 96423000000),
            BalanceSheet(date: "2021-09-25", reportedCurrency: "USD", totalCurrentAssets: 134836000000, totalNonCurrentAssets: 216166000000, shortTermDebt: 15613000000, totalCurrentLiabilities: 125481000000, longTermDebt: 109106000000,  totalNonCurrentLiabilities: 162431000000, netDebt: 89779000000),
            BalanceSheet(date: "2020-09-26", reportedCurrency: "USD", totalCurrentAssets: 143713000000, totalNonCurrentAssets: 180175000000, shortTermDebt: 13769000000, totalCurrentLiabilities: 105392000000, longTermDebt: 98667000000, totalNonCurrentLiabilities: 153157000000, netDebt: 74420000000),
              BalanceSheet(date: "2019-09-28", reportedCurrency: "USD", totalCurrentAssets: 162819000000, totalNonCurrentAssets: 175697000000, shortTermDebt: 16240000000, totalCurrentLiabilities: 105718000000, longTermDebt: 91807000000, totalNonCurrentLiabilities: 142310000000, netDebt: 59203000000),
             BalanceSheet(date: "2018-09-29", reportedCurrency: "USD", totalCurrentAssets: 234386000000, totalNonCurrentAssets: 234386000000, shortTermDebt: 20748000000, totalCurrentLiabilities: 116866000000, longTermDebt: 93735000000, totalNonCurrentLiabilities: 141712000000, netDebt: 88570000000)
        ]
    }
    
    func fetchCashFlowStatement() async -> [CashFlowStatement] {
        return [
            CashFlowStatement(date: "2022-09-24", reportedCurrency: "USD", operatingCashFlow: 122151000000, capitalExpenditure: -10708000000, freeCashFlow: 111443000000),
            CashFlowStatement(date: "2021-09-25", reportedCurrency: "USD", operatingCashFlow: 104038000000, capitalExpenditure: -11085000000, freeCashFlow: 92953000000),
            CashFlowStatement(date: "2020-09-26", reportedCurrency: "USD", operatingCashFlow: 80674000000, capitalExpenditure: -7309000000, freeCashFlow: 3365000000),
            CashFlowStatement(date: "2019-09-28", reportedCurrency: "USD", operatingCashFlow: 69391000000, capitalExpenditure: -10495000000, freeCashFlow: 58896000000),
            CashFlowStatement(date: "2018-09-29", reportedCurrency: "USD", operatingCashFlow: 77434000000, capitalExpenditure: -13313000000, freeCashFlow: 64121000000)
        ]
    }
}

protocol FinanceServiceProtocol {
    func fetchIncomeStatement() async -> [IncomeStatement]
    func fetchBalanceSheet() async -> [BalanceSheet]
    func fetchCashFlowStatement() async -> [CashFlowStatement]
}

