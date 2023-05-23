import Foundation

struct IncomeStatement: Codable, Hashable {
    let date: String
    let reportedCurrency: String
    let revenue: Int
    let grossProfit: Int
    let operatingIncome: Int
    let incomeBeforeTax: Int
    let incomeTaxExpense: Int
    let netIncome: Int
    let shareOutstanding: Int
    
    var grossMargin: Int {
        return Int(Double(grossProfit) / Double(revenue) * 100)
    }
    var operatingMargin: Int {
        return Int(Double(operatingIncome) / Double(revenue) * 100)
    }
    var netMargin: Int {
        return Int(Double(netIncome) / Double(revenue) * 100)
    }
    
    enum CodingKeys: String, CodingKey {
        case date
        case reportedCurrency
        case revenue
        case grossProfit
        case operatingIncome
        case incomeBeforeTax
        case incomeTaxExpense
        case netIncome
        case shareOutstanding = "weightedAverageShsOut"
    }
}

struct BalanceSheet: Decodable {
    let date: String
    let reportedCurrency: String
    let totalCurrentAssets: Int
    let totalNonCurrentAssets: Int
    let shortTermDebt: Int
    let totalCurrentLiabilities: Int
    let longTermDebt: Int
    let totalNonCurrentLiabilities: Int
    let netDebt: Int
    
    var totalAssets: Int {
        return totalCurrentAssets + totalNonCurrentAssets
    }
    var totalLiabilities: Int {
        return totalCurrentLiabilities + totalNonCurrentLiabilities
    }
    
    var totalEquity: Int {
        return totalAssets - totalLiabilities
    }
}

struct CashFlowStatement: Decodable {
    let date: String
    let reportedCurrency: String
    let operatingCashFlow: Int
    let capitalExpenditure: Int
    let freeCashFlow: Int
}

