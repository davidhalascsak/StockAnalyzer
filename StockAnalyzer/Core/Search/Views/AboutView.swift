import SwiftUI

struct AboutView: View {
    let company: Company
    
    init(company: Company) {
        self.company = company
        
    }
    var body: some View {
        VStack(alignment: .leading) {
            Text(company.description)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 5)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Sector")
                        .fontWeight(.semibold)
                    Text(company.sector)
                        .padding(.bottom, 10)
                    
                    Text("Industry")
                        .fontWeight(.semibold)
                    Text(company.industry)
                }
                VStack(alignment: .leading) {
                    Text("CEO")
                        .fontWeight(.semibold)
                    Text(company.ceo)
                        .padding(.bottom, 10)
                    
                    Text("Employees")
                        .fontWeight(.semibold)
                    Text(company.fullTimeEmployees)
                }
                Spacer()
            }
        }
        .padding()
    }
}

struct AboutView_Previews: PreviewProvider {
    static let company = Company(symbol: "AAPL", price: 145.85, changes:  2.4200134, exchangeShortName: "NASDAQ", companyName: "Apple Inc.", currency: "USD", industry: "Consumer Electronics", description: "Apple Inc. designs, manufactures, and markets smartphones, personal computers, tablets, wearables, and accessories worldwide. It also sells various related services. The company offers iPhone, a line of smartphones; Mac, a line of personal computers; iPad, a line of multi-purpose tablets; and wearables, home, and accessories comprising AirPods, Apple TV, Apple Watch, Beats products, HomePod, iPod touch, and other Apple-branded and third-party accessories. It also provides AppleCare support services; cloud services store services; and operates various platforms, including the App Store, that allow customers to discover and download applications and digital content, such as books, music, video, games, and podcasts. In addition, the company offers various services, such as Apple Arcade, a game subscription service; Apple Music, which offers users a curated listening experience with on-demand radio stations; Apple News+, a subscription news and magazine service; Apple TV+, which offers exclusive original content; Apple Card, a co-branded credit card; and Apple Pay, a cashless payment service, as well as licenses its intellectual property. The company serves consumers, and small and mid-sized businesses; and the education, enterprise, and government markets. It sells and delivers third-party applications for its products through the App Store. The company also sells its products through its retail and online stores, and direct sales force; and third-party cellular network carriers, wholesalers, retailers, and resellers. Apple Inc. was founded in 1977 and is headquartered in Cupertino, California.", ceo: "Mr. Timothy Cook", sector: "Technology", country: "US", fullTimeEmployees: "147000", city: "Cupertino", state: "CALIFORNIA", image: "https://financialmodelingprep.com/image-stock/AAPL.png")
    
    static var previews: some View {
        AboutView(company: company)
    }
}