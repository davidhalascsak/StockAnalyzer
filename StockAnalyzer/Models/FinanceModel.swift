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
    let weightedAverageShsOut: Int
    
    var grossMargin: Int {
        return Int(Double(grossProfit) / Double(revenue) * 100)
    }
    var operatingMargin: Int {
        return Int(Double(operatingIncome) / Double(revenue) * 100)
    }
    var netMargin: Int {
        return Int(Double(netIncome) / Double(revenue) * 100)
    }
}


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
    
    var totalAssets: Int {
        return self.totalCurrentAssets + self.totalNonCurrentAssets
    }
    var totalLiabilities: Int {
        return self.totalCurrentLiabilities + self.totalNonCurrentLiabilities
    }
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

