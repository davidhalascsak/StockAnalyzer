import SwiftUI

struct ValuationView: View {
    @StateObject var vm: ValuationViewModel
    
    init(company: Company) {
        _vm = StateObject(wrappedValue: ValuationViewModel(company: company))
    }
    var body: some View {
        if vm.ratios != nil, vm.marketCap != nil {
            VStack(alignment: .leading) {
                Text("Ratios")
                    .font(.title2)
                ratioView
            }
            .padding()
        } else {
            Spacer()
            ProgressView()
            Spacer()
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
                .padding(.vertical, 3)
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
                .padding(.vertical, 3)
            }
        }
        .padding(.horizontal)
        .background(Color.gray.opacity(0.15))
        .cornerRadius(10)
    }
}

struct ValuationView_Previews: PreviewProvider {
    static let company = Company(symbol: "AAPL", price: 145.85, changes:  2.4200134, exchangeShortName: "NASDAQ", companyName: "Apple Inc.", currency: "USD", industry: "Consumer Electronics", description: "Apple Inc. designs, manufactures, and markets smartphones, personal computers, tablets, wearables, and accessories worldwide. It also sells various related services. The company offers iPhone, a line of smartphones; Mac, a line of personal computers; iPad, a line of multi-purpose tablets; and wearables, home, and accessories comprising AirPods, Apple TV, Apple Watch, Beats products, HomePod, iPod touch, and other Apple-branded and third-party accessories. It also provides AppleCare support services; cloud services store services; and operates various platforms, including the App Store, that allow customers to discover and download applications and digital content, such as books, music, video, games, and podcasts. In addition, the company offers various services, such as Apple Arcade, a game subscription service; Apple Music, which offers users a curated listening experience with on-demand radio stations; Apple News+, a subscription news and magazine service; Apple TV+, which offers exclusive original content; Apple Card, a co-branded credit card; and Apple Pay, a cashless payment service, as well as licenses its intellectual property. The company serves consumers, and small and mid-sized businesses; and the education, enterprise, and government markets. It sells and delivers third-party applications for its products through the App Store. The company also sells its products through its retail and online stores, and direct sales force; and third-party cellular network carriers, wholesalers, retailers, and resellers. Apple Inc. was founded in 1977 and is headquartered in Cupertino, California.", ceo: "Mr. Timothy Cook", sector: "Technology", country: "US", fullTimeEmployees: "147000", city: "Cupertino", state: "CALIFORNIA", image: "https://financialmodelingprep.com/image-stock/AAPL.png")
    
    static var previews: some View {
        ValuationView(company: company)
    }
}
