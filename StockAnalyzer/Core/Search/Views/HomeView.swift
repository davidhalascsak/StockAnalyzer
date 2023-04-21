import SwiftUI

struct HomeView: View {
    @StateObject var vm: HomeViewModel
    @Binding var isNewViewPresented: Bool
    
    init(company: Company, newsService: NewsServiceProtocol, isNewViewPresented: Binding<Bool>) {
        _vm = StateObject(wrappedValue: HomeViewModel(company: company, newsService: newsService))
        _isNewViewPresented = isNewViewPresented
        UIPageControl.appearance().currentPageIndicatorTintColor = .black
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if vm.isDownloadingNews == false {
                ChartView(symbol: vm.companyProfile.symbol, exchange: vm.companyProfile.exchangeShortName, chartService: ChartService(symbol: vm.companyProfile.symbol))
                    .padding(.bottom, 2.0)
                newsView
                Text("Feed")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                FeedBodyView(symbol: vm.companyProfile.symbol, isNewViewPresented: $isNewViewPresented, userService: UserService(), postService: PostService(), imageService: ImageService())
            } else {
                ProgressView()
            }
        }
        .task {
            vm.isDownloadingNews = true
            await vm.fetchNews()
        }
    }
    
     
    var newsView: some View {
        VStack(alignment: .leading) {
            Text("Latest News")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal)
            
            if vm.news.count > 0 {
                    TabView {
                            ForEach(vm.news, id: \.self) { news in
                                if URL(string: news.news_url) != nil {
                                    VStack(alignment: .leading) {
                                        NewsRowView(news: news)
                                    }
                                    .padding(.trailing, 3)
                                    .background(Color.gray.opacity(0.15))
                                    .cornerRadius(20)
                                    .padding(.horizontal, 5)
                                    .padding(.bottom, 50)
                                }
                            }
                    }
                    .tabViewStyle(.page)
                    .frame(height: 150)
            } else {
                HStack {
                    Spacer()
                    ProgressView()
                        .frame(height: 150)
                    Spacer()
                }   
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static let company = Company(symbol: "AAPL", price: 145.85, changes:  2.4200134, exchangeShortName: "NASDAQ", companyName: "Apple Inc.", currency: "USD", industry: "Consumer Electronics", description: "Apple Inc. designs, manufactures, and markets smartphones, personal computers, tablets, wearables, and accessories worldwide. It also sells various related services. The company offers iPhone, a line of smartphones; Mac, a line of personal computers; iPad, a line of multi-purpose tablets; and wearables, home, and accessories comprising AirPods, Apple TV, Apple Watch, Beats products, HomePod, iPod touch, and other Apple-branded and third-party accessories. It also provides AppleCare support services; cloud services store services; and operates various platforms, including the App Store, that allow customers to discover and download applications and digital content, such as books, music, video, games, and podcasts. In addition, the company offers various services, such as Apple Arcade, a game subscription service; Apple Music, which offers users a curated listening experience with on-demand radio stations; Apple News+, a subscription news and magazine service; Apple TV+, which offers exclusive original content; Apple Card, a co-branded credit card; and Apple Pay, a cashless payment service, as well as licenses its intellectual property. The company serves consumers, and small and mid-sized businesses; and the education, enterprise, and government markets. It sells and delivers third-party applications for its products through the App Store. The company also sells its products through its retail and online stores, and direct sales force; and third-party cellular network carriers, wholesalers, retailers, and resellers. Apple Inc. was founded in 1977 and is headquartered in Cupertino, California.", ceo: "Mr. Timothy Cook", sector: "Technology", country: "US", fullTimeEmployees: "147000", city: "Cupertino", state: "CALIFORNIA", image: "https://financialmodelingprep.com/image-stock/AAPL.png")
    
    @State static var isNewViewPresented: Bool = false
    
    static var previews: some View {
        HomeView(company: company, newsService: NewsService(symbol: company.symbol), isNewViewPresented: $isNewViewPresented)
    }
}

