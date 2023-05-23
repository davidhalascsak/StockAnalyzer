import Foundation

@MainActor
class FinancialViewModel: ObservableObject {
    @Published var incomeStatement: [IncomeStatement] = []
    @Published var balanceSheet: [BalanceSheet] = []
    @Published var cashFlowStatement: [CashFlowStatement] = []
    @Published var isLoading: Bool = true
    
    let company: CompanyProfile
    let financeService: FinanceServiceProtocol
    
    init(company: CompanyProfile, financeService: FinanceServiceProtocol) {
        self.company = company
        self.financeService = financeService
    }
    
    func fetchData() async {
        async let fetchIncomeStatement = financeService.fetchIncomeStatement()
        async let fetchBalanceSheet = financeService.fetchBalanceSheet()
        async let fetchCashFlowStatement = financeService.fetchCashFlowStatement()
        
        let (incomeStatement, balanceSheet, cashFlowStatement) = await (fetchIncomeStatement, fetchBalanceSheet, fetchCashFlowStatement)
        
        self.incomeStatement = incomeStatement
        self.balanceSheet = balanceSheet
        self.cashFlowStatement = cashFlowStatement
        
        if !incomeStatement.isEmpty && !balanceSheet.isEmpty && !cashFlowStatement.isEmpty {
            isLoading = false
        }
    }
    
    func calculateROE() -> String {
        let taxRate =  Double(incomeStatement[0].incomeTaxExpense) / Double(incomeStatement[0].incomeBeforeTax)
        let nopat = Double(incomeStatement[0].operatingIncome) * (1.0 - taxRate)
        
        let roe = nopat / Double(balanceSheet[0].totalAssets - balanceSheet[0].totalLiabilities)
        return String(format: "%.0f", abs(roe) < 0.01 ? 0 : 100 * roe)
    }
    
    func calculateROA() -> String {
        let taxRate =  Double(incomeStatement[0].incomeTaxExpense) / Double(incomeStatement[0].incomeBeforeTax)
        let nopat = Double(incomeStatement[0].operatingIncome) * (1.0 - taxRate)
        
        let roa = nopat / Double(balanceSheet[0].totalAssets)
        return String(format: "%.0f", abs(roa) < 0.01 ? 0 : 100 * roa)
    }
    
    func calculateROIC() -> String {
        let taxRate =  Double(incomeStatement[0].incomeTaxExpense) / Double(incomeStatement[0].incomeBeforeTax)
        let nopat = Double(incomeStatement[0].operatingIncome) * (1.0 - taxRate)
        
        let investedCapital = balanceSheet[0].shortTermDebt + balanceSheet[0].longTermDebt + balanceSheet[0].totalEquity
        let roic = nopat / Double(investedCapital)
        
        return String(format: "%.0f", abs(roic) < 0.01 ? 0 : 100 * roic)
    }
    
    func calculateROCE() -> String {
        let roce = Double(incomeStatement[0].incomeBeforeTax) / Double(balanceSheet[0].totalAssets - balanceSheet[0].totalCurrentLiabilities)
        return String(format: "%.0f", abs(roce) < 0.01 ? 0 : 100 * roce)
    }
    
    func calculateDebtToEquity() -> String {
        let equity = balanceSheet[0].totalAssets - balanceSheet[0].totalLiabilities
        let ratio = Double(balanceSheet[0].shortTermDebt + balanceSheet[0].longTermDebt) / Double(equity)
        
        return String(format: "%.2f", ratio)
    }
    
    func calculateFcfMargin() -> String {
        return String(format: "%.0f", (Double(cashFlowStatement[0].freeCashFlow) / Double(incomeStatement[0].revenue) * 100))
    }
}
