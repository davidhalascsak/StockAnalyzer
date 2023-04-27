import SwiftUI

struct ValuationView: View {
    @StateObject var vm: ValuationViewModel
    
    
    init(company: Company, stockService: StockServiceProtocol) {
        _vm = StateObject(wrappedValue: ValuationViewModel(company: company, stockService: stockService))
        UIPickerView.appearance().tintColor = .black
    }
    var body: some View {
        VStack {
            if vm.isLoading == false {
                VStack(alignment: .leading) {
                    Text("Ratios")
                        .font(.title2)
                        .fontWeight(.semibold)
                    ratioView
                    Text("Valuation")
                        .font(.title2)
                        .fontWeight(.semibold)
                    valuationView
                }
                .padding()
            } else {
                Spacer()
                ProgressView()
                Spacer()
            }
        }
        .task {
            await vm.fetchData()
            vm.calculateIntrinsicValue()
        }
    }
    
    var ratioView: some View {
        HStack {
            if let ratios = vm.ratios, let marketCap = vm.marketCap {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Market Cap")
                    Text("PE Ratio")
                    Text("PEG Ratio")
                    Text("Price/Sales")
                    Text("Price/Book")
                    Text("Dividend & Yield")
                    
                }
                .padding(.vertical, 5)
                Spacer()
                VStack(alignment: .trailing, spacing: 3) {
                    Text(vm.formatPrice(price: marketCap.marketCap))
                    Text(ratios.peRatioTTM > 0 ? String(format: "%.2f", ratios.peRatioTTM) : "N/A")
                    Text(ratios.pegRatioTTM > 0 ? String(format: "%.2f", ratios.pegRatioTTM) : "N/A")
                    Text(String(format: "%.2f", ratios.priceToSalesRatioTTM))
                    Text(String(format: "%.2f", ratios.priceToBookRatioTTM))
                    if ratios.dividendPerShareTTM != 0 {
                        HStack(spacing: 2) {
                            Text(String(format: "%.2f", ratios.dividendPerShareTTM))
                            Text("(\(String(format: "%.2f", ratios.dividendYielPercentageTTM))%)")
                        }
                    } else {
                        HStack(spacing: 2) {
                            Text("N/A")
                            Text("(N/A)")
                        }
                    }
                }
                .fontWeight(.semibold)
                .padding(.vertical, 5)
            }
        }
        .padding(.horizontal)
        .background(Color.gray.opacity(0.15))
        .cornerRadius(10)
    }
    
    var valuationView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Method:")
                Spacer()
                Picker("Method", selection: $vm.valuationType) {
                    ForEach(vm.options, id: \.self) {
                        Text($0)
                    }
                }
                .padding(-6)
                .background(Color.white)
                .cornerRadius(10)
            }
            .padding(.top, 8)
            .padding(.horizontal, 20)
            HStack {
                Text(vm.valuationType == "Net Income" ? "Net Income:" : "Free Cash Flow:")
                Spacer()
                TextField("", value: $vm.baseValue, format: .number)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .padding(.horizontal, 5)
                    .frame(width: 100)
                    .background(Color.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            HStack {
                Text("Growth Rate:")
                Spacer()
                HStack(spacing: 0) {
                    TextField("", value: $vm.growthRate, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 75)
                    Text("%")
                }
                .padding(.horizontal, 6)
                .background(Color.white)
                .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            HStack {
                Text("Discount Rate:")
                Spacer()
                HStack(spacing: 0) {
                    TextField("", value: $vm.discountRate, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 75)
                    Text("%")
                }
                .padding(.horizontal, 5)
                .background(Color.white)
                .cornerRadius(10)
            }
            .padding(.horizontal, 20) 
            HStack(spacing: 0) {
                Text("Terminal Multiple:")
                Spacer()
                TextField("", value: $vm.terminalMultiple, format: .number)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .padding(.horizontal, 5)
                    .frame(width: 100)
                    .background(Color.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            HStack() {
                Spacer()
                Text("Intrinsic Value: ")
                Text(vm.intrinsicValue)
                Spacer()
            }
            .font(Font.title3)
            .padding(.vertical, 10)
        }
        .background(Color.gray.opacity(0.15))
        .cornerRadius(10)
        .onChange(of: vm.valuationType) { _ in
            vm.resetValuation()
            vm.calculateIntrinsicValue()
        }
    }
}

struct ValuationView_Previews: PreviewProvider {
    static let company = Company(symbol: "AAPL", price: 145.85, changes:  2.4200134, exchangeShortName: "NASDAQ", companyName: "Apple Inc.", currency: "USD", industry: "Consumer Electronics", description: "Apple Inc. designs, manufactures, and markets smartphones, personal computers, tablets, wearables, and accessories worldwide. It also sells various related services. The company offers iPhone, a line of smartphones; Mac, a line of personal computers; iPad, a line of multi-purpose tablets; and wearables, home, and accessories comprising AirPods, Apple TV, Apple Watch, Beats products, HomePod, iPod touch, and other Apple-branded and third-party accessories. It also provides AppleCare support services; cloud services store services; and operates various platforms, including the App Store, that allow customers to discover and download applications and digital content, such as books, music, video, games, and podcasts. In addition, the company offers various services, such as Apple Arcade, a game subscription service; Apple Music, which offers users a curated listening experience with on-demand radio stations; Apple News+, a subscription news and magazine service; Apple TV+, which offers exclusive original content; Apple Card, a co-branded credit card; and Apple Pay, a cashless payment service, as well as licenses its intellectual property. The company serves consumers, and small and mid-sized businesses; and the education, enterprise, and government markets. It sells and delivers third-party applications for its products through the App Store. The company also sells its products through its retail and online stores, and direct sales force; and third-party cellular network carriers, wholesalers, retailers, and resellers. Apple Inc. was founded in 1977 and is headquartered in Cupertino, California.", ceo: "Mr. Timothy Cook", sector: "Technology", country: "US", fullTimeEmployees: "147000", city: "Cupertino", state: "CALIFORNIA", image: "https://financialmodelingprep.com/image-stock/AAPL.png")
    
    static var previews: some View {
        ValuationView(company: company, stockService: StockService(symbol: company.symbol))
    }
}
