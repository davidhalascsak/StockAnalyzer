import SwiftUI
import Charts

struct FinancialView: View {
    @StateObject var vm: FinancialViewModel
    
    init(company: CompanyProfile, financeService: FinanceServiceProtocol) {
        _vm = StateObject(wrappedValue: FinancialViewModel(company: company, financeService: financeService))
    }
    
    var body: some View {
        VStack {
            if vm.isLoading == false {
                VStack(alignment: .leading) {
                    incomeView
                    balanceSheetView
                    cashFlowView
                    efficiencyView
                }
                .padding()
            } else {
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
        .task {
            await vm.fetchData()
        }
    }
    var incomeView: some View {
        VStack(alignment: .leading) {
            Text("Income Statement")
                .font(.title2)
                .fontWeight(.bold)
            BarChartView(title: "Revenue", xData: vm.incomeStatement.map({ $0.date }).reversed(), yData: vm.incomeStatement.map({ $0.revenue }).reversed(), intervals: [1,3,5,10], isInverted: false, reversePrefix: false)
            BarChartView(title: "Operating Income", xData: vm.incomeStatement.map({ $0.date }).reversed(), yData: vm.incomeStatement.map({ $0.operatingIncome }).reversed(), intervals: [1,3,5,10], isInverted: false, reversePrefix: false)
            BarChartView(title: "Net Income", xData: vm.incomeStatement.map({ $0.date }).reversed(), yData: vm.incomeStatement.map({ $0.netIncome }).reversed(), intervals: [1,3,5,10], isInverted: false, reversePrefix: false)
        }
    }
    
    var balanceSheetView: some View {
        VStack(alignment: .leading) {
            Text("Balance Sheet")
                .font(.title2)
                .fontWeight(.bold)
            HStack {
                Spacer()
                PieChartView(values: [vm.balanceSheet[0].totalAssets, vm.balanceSheet[0].totalLiabilities ], default_name: "Total Equity", names: ["Total Assets", "Total Liabilities"], formatter: {value in vm.formatPrice(price: value)}, colors: [Color.green, Color.red])
                Spacer()
            }
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Net Debt")
                    Text("Debt to Equity")
                }
                .padding(.vertical, 3)
                Spacer()
                VStack(alignment: .trailing, spacing: 3) {
                    Text("\(vm.balanceSheet[0].netDebt)")
                    Text("\(vm.calculateDebtToEquity())")
                }
                .fontWeight(.semibold)
                .padding(.vertical, 3)
            }
            .padding(.horizontal)
            .background(Color.gray.opacity(0.15))
            .cornerRadius(10)
            BarChartView(title: "Share Outstanding", xData: vm.incomeStatement.map({$0.date}).reversed(), yData: vm.incomeStatement.map({$0.weightedAverageShsOut}).reversed(), intervals: [1,3,5,10], isInverted: true, reversePrefix: false)
        }
    }
    
    var cashFlowView: some View {
        VStack(alignment: .leading) {
            Text("Cash Flow")
                .font(.title2)
                .fontWeight(.bold)
            BarChartView(title: "Operating Cash Flow", xData: vm.cashFlowStatement.map({ $0.date }).reversed(), yData: vm.cashFlowStatement.map({ $0.operatingCashFlow }).reversed(), intervals: [1,3,5,10], isInverted: false, reversePrefix: false)
            BarChartView(title: "Capital Expenditure", xData: vm.cashFlowStatement.map({ $0.date }).reversed(), yData: vm.cashFlowStatement.map({ $0.capitalExpenditure }).reversed(), intervals: [1,3,5,10], isInverted: true, reversePrefix: true)
            BarChartView(title: "Free Cash Flow", xData: vm.cashFlowStatement.map({ $0.date }).reversed(), yData: vm.cashFlowStatement.map({ $0.freeCashFlow }).reversed(), intervals: [1,3,5,10], isInverted: false, reversePrefix: false)
        }
    }
    
    var efficiencyView: some View {
        VStack(alignment: .leading) {
            Text("Efficiency")
                .font(.title2)
                .fontWeight(.bold)
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Gross Margin:")
                    Text("Operating Margin:")
                    Text("Income Margin:")
                    Text("Free Cash Flow Margin:")
                }
                .padding(.vertical, 5)
                Spacer()
                VStack(alignment: .trailing, spacing: 3) {
                    Text("\(vm.incomeStatement[0].grossMargin)%")
                    Text("\(vm.incomeStatement[0].operatingMargin)%")
                    Text("\(vm.incomeStatement[0].netMargin)%")
                    Text("\(vm.calculateFcfMargin())%")
                }
                .fontWeight(.semibold)
                .padding(.vertical, 5)
            }
            .padding(.horizontal)
            .background(Color.gray.opacity(0.15))
            .cornerRadius(10)
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Return on Equity:")
                    Text("Return on Assets:")
                    Text("Return on Invested Capital:")
                    Text("Return on Capital Employed:")
                }
                .padding(.vertical, 5)
                Spacer()
                VStack(alignment: .trailing, spacing: 3) {
                    Text("\(vm.calculateROE())%")
                    Text("\(vm.calculateROA())%")
                    Text("\(vm.calculateROIC())%")
                    Text("\(vm.calculateROCE())%")
                }
                .fontWeight(.semibold)
                .padding(.vertical, 5)
            }
            .padding(.horizontal)
            .background(Color.gray.opacity(0.15))
            .cornerRadius(10)
        }
    }
}

struct FinancialView_Previews: PreviewProvider {
    static let company = CompanyProfile(symbol: "AAPL", price: 145.85, changes:  2.4200134,currency: "USD", exchangeShortName: "NASDAQ", companyName: "Apple Inc.", description: "Apple Inc. designs, manufactures, and markets smartphones, personal computers, tablets, wearables, and accessories worldwide. It also sells various related services. The company offers iPhone, a line of smartphones; Mac, a line of personal computers; iPad, a line of multi-purpose tablets; and wearables, home, and accessories comprising AirPods, Apple TV, Apple Watch, Beats products, HomePod, iPod touch, and other Apple-branded and third-party accessories. It also provides AppleCare support services; cloud services store services; and operates various platforms, including the App Store, that allow customers to discover and download applications and digital content, such as books, music, video, games, and podcasts. In addition, the company offers various services, such as Apple Arcade, a game subscription service; Apple Music, which offers users a curated listening experience with on-demand radio stations; Apple News+, a subscription news and magazine service; Apple TV+, which offers exclusive original content; Apple Card, a co-branded credit card; and Apple Pay, a cashless payment service, as well as licenses its intellectual property. The company serves consumers, and small and mid-sized businesses; and the education, enterprise, and government markets. It sells and delivers third-party applications for its products through the App Store. The company also sells its products through its retail and online stores, and direct sales force; and third-party cellular network carriers, wholesalers, retailers, and resellers. Apple Inc. was founded in 1977 and is headquartered in Cupertino, California.",fullTimeEmployees: "147000" ,  industry: "Consumer Electronics", sector: "Technology", ceo: "Mr. Timothy Cook", country: "US",  state: "CALIFORNIA",city: "Cupertino", image: "https://financialmodelingprep.com/image-stock/AAPL.png")
    
    
    static var previews: some View {
        FinancialView(company: company, financeService: FinanceService(symbol: company.symbol))
    }
}
