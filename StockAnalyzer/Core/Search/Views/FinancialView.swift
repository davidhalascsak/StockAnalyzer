import SwiftUI
import Charts

struct FinancialView: View {
    @StateObject var vm: FinancialViewModel
    @State private var selectedDate: String = ""
    
    init(company: Company) {
        _vm = StateObject(wrappedValue: FinancialViewModel(company: company))
    }
    
    var body: some View {
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
    var incomeView: some View {
        VStack(alignment: .leading) {
            Text("Income Statement")
                .font(.title2)
                .fontWeight(.bold)
            BarChartView(title: "Revenue", xData: vm.incomeStatement.map({ $0.date }).reversed(), yData: vm.incomeStatement.map({ $0.revenue }).reversed(), isInverted: false)
            BarChartView(title: "Operating Income", xData: vm.incomeStatement.map({ $0.date }).reversed(), yData: vm.incomeStatement.map({ $0.operatingIncome }).reversed(), isInverted: false)
            BarChartView(title: "Net Income", xData: vm.incomeStatement.map({ $0.date }).reversed(), yData: vm.incomeStatement.map({ $0.netIncome }).reversed(), isInverted: false)
        }
    }
    
    var balanceSheetView: some View {
        Text("Balance Sheet")
            .font(.title2)
            .fontWeight(.bold)
        // total assets vs total liabilities
        // net debt
        // debt to equity
    }
    
    var cashFlowView: some View {
        VStack(alignment: .leading) {
            Text("Cash Flow")
                .font(.title2)
                .fontWeight(.bold)
            BarChartView(title: "Operating Cash Flow", xData: vm.cashFlowStatement.map({ $0.date }).reversed(), yData: vm.cashFlowStatement.map({ $0.operatingCashFlow }).reversed(), isInverted: false)
            BarChartView(title: "Capital Expenditure", xData: vm.cashFlowStatement.map({ $0.date }).reversed(), yData: vm.cashFlowStatement.map({ $0.capitalExpenditure }).reversed(), isInverted: true)
            BarChartView(title: "Free Cash Flow", xData: vm.cashFlowStatement.map({ $0.date }).reversed(), yData: vm.cashFlowStatement.map({ $0.freeCashFlow }).reversed(), isInverted: false)
        }
    }
    
    var efficiencyView: some View {
        VStack(alignment: .leading) {
            Text("Efficiency")
                .font(.title2)
                .fontWeight(.bold)
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Return on Equity")
                    Text("Return on Assets")
                    Text("Return on Invested Capital")
                    Text("Return on Capital Employed")
                }
                .padding(.vertical, 3)
                Spacer()
                VStack(alignment: .trailing, spacing: 3) {
                    Text("\(vm.calculateROE())%")
                    Text("\(vm.calculateROA())%")
                    Text("\(vm.calculateROIC())%")
                    Text("\(vm.calculateROCE())%")
                }
                .fontWeight(.semibold)
                .padding(.vertical, 3)
            }
            .padding(.horizontal)
            .background(Color.gray.opacity(0.15))
            .cornerRadius(10)
        }
    }
}

struct FinancialView_Previews: PreviewProvider {
    static let company = Company(symbol: "AAPL", price: 145.85, changes:  2.4200134, exchangeShortName: "NASDAQ", companyName: "Apple Inc.", currency: "USD", industry: "Consumer Electronics", description: "Apple Inc. designs, manufactures, and markets smartphones, personal computers, tablets, wearables, and accessories worldwide. It also sells various related services. The company offers iPhone, a line of smartphones; Mac, a line of personal computers; iPad, a line of multi-purpose tablets; and wearables, home, and accessories comprising AirPods, Apple TV, Apple Watch, Beats products, HomePod, iPod touch, and other Apple-branded and third-party accessories. It also provides AppleCare support services; cloud services store services; and operates various platforms, including the App Store, that allow customers to discover and download applications and digital content, such as books, music, video, games, and podcasts. In addition, the company offers various services, such as Apple Arcade, a game subscription service; Apple Music, which offers users a curated listening experience with on-demand radio stations; Apple News+, a subscription news and magazine service; Apple TV+, which offers exclusive original content; Apple Card, a co-branded credit card; and Apple Pay, a cashless payment service, as well as licenses its intellectual property. The company serves consumers, and small and mid-sized businesses; and the education, enterprise, and government markets. It sells and delivers third-party applications for its products through the App Store. The company also sells its products through its retail and online stores, and direct sales force; and third-party cellular network carriers, wholesalers, retailers, and resellers. Apple Inc. was founded in 1977 and is headquartered in Cupertino, California.", ceo: "Mr. Timothy Cook", sector: "Technology", country: "US", fullTimeEmployees: "147000", city: "Cupertino", state: "CALIFORNIA", image: "https://financialmodelingprep.com/image-stock/AAPL.png")
    
    static var previews: some View {
        FinancialView(company: company)
    }
}
