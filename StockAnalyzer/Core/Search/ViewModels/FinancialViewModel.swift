import Foundation

@MainActor
class FinancialViewModel: ObservableObject {
    @Published var incomeStatement: [IncomeStatement] = []
    @Published var balanceSheet: [BalanceSheet] = []
    @Published var cashFlowStatement: [CashFlowStatement] = []
    @Published var isLoading: Bool = true
    
    let company: Company
    let financeService: FinanceServiceProtocol
    
    init(company: Company, financeService: FinanceServiceProtocol) {
        self.company = company
        self.financeService = financeService
    }
    
    func fetchData() async {
        async let fetchIncomeStatement = self.financeService.fetchIncomeStatement()
        async let fetchBalanceSheet = self.financeService.fetchBalanceSheet()
        async let fetchCashFlowStatement = self.financeService.fetchCashFlowStatement()
        
        let (incomeStatement, balanceSheet, cashFlowStatement) = await (fetchIncomeStatement, fetchBalanceSheet, fetchCashFlowStatement)
        
        self.incomeStatement = incomeStatement
        self.balanceSheet = balanceSheet
        self.cashFlowStatement = cashFlowStatement
        
        if !incomeStatement.isEmpty && !balanceSheet.isEmpty && !cashFlowStatement.isEmpty {
            self.isLoading = false
        }
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
    
    func calculateNetDebt() -> String {
        let ratio = self.balanceSheet[0].shortTermDebt + self.balanceSheet[0].longTermDebt - self.balanceSheet[0].cashAndCashEquivalents
        
        return self.formatPrice(price: ratio)
    }
    
    func calculateDebtToEquity() -> String {
        let equity = self.balanceSheet[0].totalAssets - self.balanceSheet[0].totalLiabilities
        let ratio = Double(self.balanceSheet[0].shortTermDebt + self.balanceSheet[0].longTermDebt) / Double(equity)
        
        return String(format: "%.2f", ratio)
    }
    
    func calculateFcfMargin() -> Int {
        return Int(Double(self.cashFlowStatement[0].freeCashFlow) / Double(self.incomeStatement[0].revenue) * 100)
    }
    
    func formatPrice(price: Int) -> String {
        var priceAsString: String = String(price)
        var prefix = ""
        var result: String
        
        if price < 0 {
            prefix = "-"
            priceAsString = priceAsString.trimmingCharacters(in: CharacterSet(charactersIn: "-"))
        }
        
        if priceAsString.count % 3 == 0 {
            if priceAsString.count >= 6 {
                result = "\(priceAsString[0...2]).\(priceAsString[3...4])"
            } else {
                result = priceAsString
            }
        } else if priceAsString.count % 3 == 1 {
            if priceAsString.count >= 7 {
                result = "\(priceAsString[0]).\(priceAsString[1...2])"
            } else {
                result = priceAsString
            }
        } else {
            if priceAsString.count >= 8 {
                result = "\(priceAsString[0...1]).\(priceAsString[2...3])"
            } else {
                result = priceAsString
            }
        }
        
        if priceAsString.count >= 7 && priceAsString.count < 10 {
            result.append("M")
        } else if 10 <= priceAsString.count && priceAsString.count < 13 {
            result.append("B")
        } else if priceAsString.count >= 13 {
            result.append("T")
        }
        
        return "\(prefix)\(result)"
    }
}
