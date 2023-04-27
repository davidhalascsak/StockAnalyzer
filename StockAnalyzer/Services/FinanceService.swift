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
            BalanceSheet(date: "2022-09-24", reportedCurrency: "USD", cashAndCashEquivalents: 23646000000, shortTermInvestments: 24658000000, netReceivables: 60932000000, inventory: 4946000000, otherCurrentAssets: 21223000000, totalCurrentAssets: 135405000000, longTermInvestments: 120805000000, propertyPlantEquipmentNet: 42117000000, goodwill: 0, intangibleAssets: 0, otherNonCurrentAssets: 54428000000, totalNonCurrentAssets: 217350000000, accountPayables: 64115000000, shortTermDebt: 21110000000, otherCurrentLiabilities: 60845000000, totalCurrentLiabilities: 153982000000, longTermDebt: 98959000000, otherNonCurrentLiabilities: 54964000000, totalNonCurrentLiabilities: 148101000000, totalInvestments: 145463000000, totalDebt: 120069000000, netDebt: 96423000000),
            BalanceSheet(date: "2021-09-25", reportedCurrency: "USD", cashAndCashEquivalents: 34940000000, shortTermInvestments: 27699000000, netReceivables: 51506000000, inventory: 6580000000, otherCurrentAssets: 14111000000, totalCurrentAssets: 134836000000, longTermInvestments: 127877000000, propertyPlantEquipmentNet: 39440000000, goodwill: 0, intangibleAssets: 0, otherNonCurrentAssets: 48849000000, totalNonCurrentAssets: 216166000000, accountPayables: 54763000000, shortTermDebt: 15613000000, otherCurrentLiabilities: 47493000000, totalCurrentLiabilities: 125481000000, longTermDebt: 109106000000, otherNonCurrentLiabilities: 84443000000, totalNonCurrentLiabilities: 162431000000, totalInvestments: 155576000000, totalDebt: 124719000000, netDebt: 89779000000),
            BalanceSheet(date: "2020-09-26", reportedCurrency: "USD", cashAndCashEquivalents: 38016000000, shortTermInvestments: 52927000000, netReceivables: 37445000000, inventory: 4061000000, otherCurrentAssets: 11264000000, totalCurrentAssets: 143713000000, longTermInvestments: 100887000000, propertyPlantEquipmentNet: 36766000000, goodwill: 0, intangibleAssets: 0, otherNonCurrentAssets: 42522000000, totalNonCurrentAssets: 180175000000, accountPayables: 42296000000, shortTermDebt: 13769000000, otherCurrentLiabilities: 42684000000, totalCurrentLiabilities: 105392000000, longTermDebt: 98667000000, otherNonCurrentLiabilities: 153157000000, totalNonCurrentLiabilities: 153157000000, totalInvestments: 153814000000, totalDebt: 112436000000, netDebt: 74420000000),
              BalanceSheet(date: "2019-09-28", reportedCurrency: "USD", cashAndCashEquivalents: 48844000000, shortTermInvestments: 51713000000, netReceivables: 45804000000, inventory: 4106000000, otherCurrentAssets: 12352000000, totalCurrentAssets: 162819000000, longTermInvestments: 105341000000, propertyPlantEquipmentNet: 37378000000, goodwill: 0, intangibleAssets: 0, otherNonCurrentAssets: 32978000000, totalNonCurrentAssets: 175697000000, accountPayables: 46236000000, shortTermDebt: 16240000000, otherCurrentLiabilities: 37720000000, totalCurrentLiabilities: 105718000000, longTermDebt: 91807000000, otherNonCurrentLiabilities: 74312000000, totalNonCurrentLiabilities: 142310000000, totalInvestments: 157054000000, totalDebt: 108047000000, netDebt: 59203000000),
             BalanceSheet(date: "2018-09-29", reportedCurrency: "USD", cashAndCashEquivalents: 25913000000, shortTermInvestments: 40388000000, netReceivables: 48995000000, inventory: 3956000000, otherCurrentAssets: 22283000000, totalCurrentAssets: 234386000000, longTermInvestments: 170799000000, propertyPlantEquipmentNet: 41304000000, goodwill: 0, intangibleAssets: 0, otherNonCurrentAssets: 22283000000, totalNonCurrentAssets: 234386000000, accountPayables: 55888000000, shortTermDebt: 20748000000, otherCurrentLiabilities: 32687000000, totalCurrentLiabilities: 116866000000, longTermDebt: 93735000000, otherNonCurrentLiabilities: 57533000000, totalNonCurrentLiabilities: 141712000000, totalInvestments: 211187000000, totalDebt: 114483000000, netDebt: 88570000000)
        ]
    }
    
    func fetchCashFlowStatement() async -> [CashFlowStatement] {
        return [
            CashFlowStatement(date: "2022-09-24", reportedCurrency: "USD", netIncome: 99803000000, netCashProvidedByOperatingActivities: 122151000000, netCashUsedForInvestingActivites: -22354000000, netCashUsedProvidedByFinancingActivities: -110749000000, stockBasedCompensation: 9038000000, debtRepayment: -9543000000, commonStockIssued: 0, commonStockRepurchased: -89402000000, dividendsPaid: -14841000000, netChangeInCash: -10952000000, cashAtBeginningOfPeriod: 35929000000, cashAtEndOfPeriod: 24977000000, operatingCashFlow: 122151000000, capitalExpenditure: -10708000000, freeCashFlow: 111443000000),
            CashFlowStatement(date: "2021-09-25", reportedCurrency: "USD", netIncome: 94680000000, netCashProvidedByOperatingActivities: 104038000000, netCashUsedForInvestingActivites: -14545000000, netCashUsedProvidedByFinancingActivities: -93353000000, stockBasedCompensation: 7906000000, debtRepayment: -8750000000, commonStockIssued: 1105000000, commonStockRepurchased: -85971000000, dividendsPaid: -14467000000, netChangeInCash: -3860000000, cashAtBeginningOfPeriod: 39789000000, cashAtEndOfPeriod: 35929000000, operatingCashFlow: 104038000000, capitalExpenditure: -11085000000, freeCashFlow: 92953000000),
            CashFlowStatement(date: "2020-09-26", reportedCurrency: "USD", netIncome: 57411000000, netCashProvidedByOperatingActivities: 80674000000, netCashUsedForInvestingActivites: -7309000000, netCashUsedProvidedByFinancingActivities: -86820000000, stockBasedCompensation: 6829000000, debtRepayment: -13592000000, commonStockIssued: 880000000, commonStockRepurchased: -72358000000, dividendsPaid: -14081000000, netChangeInCash: -10435000000, cashAtBeginningOfPeriod: 50224000000, cashAtEndOfPeriod: 39789000000, operatingCashFlow: 80674000000, capitalExpenditure: -7309000000, freeCashFlow: 3365000000),
            CashFlowStatement(date: "2019-09-28", reportedCurrency: "USD", netIncome: 55256000000, netCashProvidedByOperatingActivities: 69391000000, netCashUsedForInvestingActivites: 45896000000, netCashUsedProvidedByFinancingActivities: -90976000000, stockBasedCompensation: 6068000000, debtRepayment: -8805000000, commonStockIssued: 781000000, commonStockRepurchased: -66897000000, dividendsPaid: -14119000000, netChangeInCash: 24311000000, cashAtBeginningOfPeriod: 25913000000, cashAtEndOfPeriod: 50224000000, operatingCashFlow: 69391000000, capitalExpenditure: -10495000000, freeCashFlow: 58896000000),
             CashFlowStatement(date: "2018-09-29", reportedCurrency: "USD", netIncome: 59531000000, netCashProvidedByOperatingActivities: 77434000000, netCashUsedForInvestingActivites: 16066000000, netCashUsedProvidedByFinancingActivities: -87876000000, stockBasedCompensation: 5340000000, debtRepayment: -6500000000, commonStockIssued: 669000000, commonStockRepurchased: -72738000000, dividendsPaid: -13712000000, netChangeInCash: 5624000000, cashAtBeginningOfPeriod: 0289000000, cashAtEndOfPeriod: 25913000000, operatingCashFlow: 77434000000, capitalExpenditure: -13313000000, freeCashFlow: 64121000000)
        ]
    }
}

protocol FinanceServiceProtocol {
    func fetchIncomeStatement() async -> [IncomeStatement]
    func fetchBalanceSheet() async -> [BalanceSheet]
    func fetchCashFlowStatement() async -> [CashFlowStatement]
}

