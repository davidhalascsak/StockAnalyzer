import SwiftUI

struct ValuationView: View {
    @StateObject private var viewModel: ValuationViewModel
    @FocusState private var focusedField: FocusField?
    
    private enum FocusField {
        case baseField
        case growthRateField
        case discountRateField
        case terminalMultipleField
    }
    
    init(company: CompanyProfile, stockService: StockServiceProtocol) {
        _viewModel = StateObject(wrappedValue: ValuationViewModel(company: company, stockService: stockService))
        UIPickerView.appearance().tintColor = .black
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading == false {
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
            await viewModel.fetchData()
            viewModel.calculateIntrinsicValue()
        }
    }
    
    var ratioView: some View {
        HStack {
            if let ratios = viewModel.ratios, let marketCap = viewModel.marketCap {
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
                    Text(marketCap.formattedPrice)
                    Text(ratios.peRatio > 0 ? String(format: "%.2f", ratios.peRatio) : "N/A")
                    Text(ratios.pegRatio > 0 ? String(format: "%.2f", ratios.pegRatio) : "N/A")
                    Text(String(format: "%.2f", ratios.priceToSalesRatio))
                    Text(String(format: "%.2f", ratios.priceToBookRatio))
                    if ratios.dividendPerShare != 0 {
                        HStack(spacing: 2) {
                            Text(String(format: "%.2f", ratios.dividendPerShare))
                            Text("(\(String(format: "%.2f", ratios.dividendYieldPercentage))%)")
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
                Picker("Method", selection: $viewModel.valuationType) {
                    ForEach(ValuationViewModel.ValuationType.allCases, id: \.self) {
                        Text(String(describing: $0))
                    }
                }
                .onTapGesture {
                    focusedField = nil
                }
                .padding(-6)
                .background(Color.white)
                .cornerRadius(10)
            }
            .padding(.top, 8)
            .padding(.horizontal, 20)
            HStack {
                Text("Base: ")
                Spacer()
                TextField("", value: $viewModel.baseValue, format: .number)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .focused($focusedField, equals: .baseField)
                    .foregroundColor(Color.black)
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
                    TextField("", value: $viewModel.growthRate, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .focused($focusedField, equals: .growthRateField)
                        .foregroundColor(Color.black)
                        .frame(width: 75)
                    Text("%")
                        .foregroundColor(Color.black)
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
                    TextField("", value: $viewModel.discountRate, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .focused($focusedField, equals: .discountRateField)
                        .foregroundColor(Color.black)
                        .frame(width: 75)
                    Text("%")
                        .foregroundColor(Color.black)
                }
                .padding(.horizontal, 5)
                .background(Color.white)
                .cornerRadius(10)
            }
            .padding(.horizontal, 20) 
            HStack(spacing: 0) {
                Text("Terminal Multiple:")
                Spacer()
                TextField("", value: $viewModel.terminalMultiple, format: .number)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .focused($focusedField, equals: .terminalMultipleField)
                    .foregroundColor(Color.black)
                    .padding(.horizontal, 5)
                    .frame(width: 100)
                    .background(Color.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            HStack() {
                Spacer()
                Text("Intrinsic Value: ")
                Text(viewModel.intrinsicValue)
                Spacer()
            }
            .font(Font.title3)
            .padding(.vertical, 10)
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .onChange(of: viewModel.valuationType) { _ in
            viewModel.resetValuation()
            viewModel.calculateIntrinsicValue()
        }
    }
}

struct ValuationView_Previews: PreviewProvider {
    static let company = CompanyProfile(stockSymbol: "AAPL", price: 145.85, changes:  2.4200134,currency: "USD", exchangeShortName: "NASDAQ", companyName: "Apple Inc.", description: "Apple Inc. designs, manufactures, and markets smartphones, personal computers, tablets, wearables, and accessories worldwide. It also sells various related services. The company offers iPhone, a line of smartphones; Mac, a line of personal computers; iPad, a line of multi-purpose tablets; and wearables, home, and accessories comprising AirPods, Apple TV, Apple Watch, Beats products, HomePod, iPod touch, and other Apple-branded and third-party accessories. It also provides AppleCare support services; cloud services store services; and operates various platforms, including the App Store, that allow customers to discover and download applications and digital content, such as books, music, video, games, and podcasts. In addition, the company offers various services, such as Apple Arcade, a game subscription service; Apple Music, which offers users a curated listening experience with on-demand radio stations; Apple News+, a subscription news and magazine service; Apple TV+, which offers exclusive original content; Apple Card, a co-branded credit card; and Apple Pay, a cashless payment service, as well as licenses its intellectual property. The company serves consumers, and small and mid-sized businesses; and the education, enterprise, and government markets. It sells and delivers third-party applications for its products through the App Store. The company also sells its products through its retail and online stores, and direct sales force; and third-party cellular network carriers, wholesalers, retailers, and resellers. Apple Inc. was founded in 1977 and is headquartered in Cupertino, California.",fullTimeEmployees: "147000" ,  industry: "Consumer Electronics", sector: "Technology", ceo: "Mr. Timothy Cook", country: "US",  state: "CALIFORNIA",city: "Cupertino", image: "https://financialmodelingprep.com/image-stock/AAPL.png")
    
    static var previews: some View {
        ValuationView(company: company, stockService: StockService(stockSymbol: company.stockSymbol))
    }
}
