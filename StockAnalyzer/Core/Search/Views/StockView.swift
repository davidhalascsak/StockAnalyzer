import SwiftUI

struct StockView: View {
    @StateObject var vm: StockViewModel
    @State var isExpanded: Bool = false
    
    init(symbol: String) {
        _vm = StateObject(wrappedValue: StockViewModel(symbol: symbol))
    }
    
    
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                header
                    .padding()
                Divider()
                Text("About")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                    .padding(.bottom, 2)
                VStack {
                    Text("Apple Inc. designs, manufactures, and markets smartphones, personal computers, tablets, wearables, and accessories worldwide. It also sells various related services. The company offers iPhone, a line of smartphones; Mac, a line of personal computers; iPad, a line of multi-purpose tablets; and wearables, home, and accessories comprising AirPods, Apple TV, Apple Watch, Beats products, HomePod, iPod touch, and other Apple-branded and third-party accessories. It also provides AppleCare support services; cloud services store services; and operates various platforms, including the App Store, that allow customers to discover and download applications and digital content, such as books, music, video, games, and podcasts. In addition, the company offers various services, such as Apple Arcade, a game subscription service; Apple Music, which offers users a curated listening experience with on-demand radio stations; Apple News+, a subscription news and magazine service; Apple TV+, which offers exclusive original content; Apple Card, a co-branded credit card; and Apple Pay, a cashless payment service, as well as licenses its intellectual property. The company serves consumers, and small and mid-sized businesses; and the education, enterprise, and government markets. It sells and delivers third-party applications for its products through the App Store. The company also sells its products through its retail and online stores, and direct sales force; and third-party cellular network carriers, wholesalers, retailers, and resellers. Apple Inc. was founded in 1977 and is headquartered in Cupertino, California.")
                        .padding(.horizontal)
                        .lineLimit(isExpanded ? nil : 5)
                        .overlay(
                            GeometryReader { proxy in
                                Button(action: {
                                    withAnimation(.spring()) {
                                        isExpanded.toggle()
                                    }
                                }) {
                                    Text(isExpanded ? "Show Less" : "Show More")
                                        .font(.caption).bold()
                                        .padding(.leading, 8.0)
                                        .padding(.top, 4.0)
                                        .background(Color.white)
                                }
                                .padding(.vertical)
                                .padding(.horizontal, 8)
                                .frame(width: proxy.size.width, height: proxy.size.height + 32, alignment: .bottomLeading)
                            }
                        )
                }
                .padding(.bottom, 15)
                Divider()
                Text("News")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 10) {
                        ForEach(0..<10) { index in
                            Rectangle()
                                .cornerRadius(15)
                                .frame(width: 80, height: 80)
                        }
                    }
                    .padding(.horizontal)
                    .frame(height: 100)
                }
                Divider()
                Text("Feed")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                Spacer()
            }
        }
    }
    
    var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("Apple")
                    .font(.title)
                    .fontWeight(.bold)
                HStack {
                    Text("Technology")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(3)
                        .padding(.horizontal, 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        
                    Text("Consumer Electorincs")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(3)
                        .padding(.horizontal, 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        
                }
                
                HStack(alignment: .firstTextBaseline) {
                    Text("150.00")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("USD")
                        .font(.title2)
                }
                HStack {
                    Text("-2.02")
                        
                    Text("(-1.1%)")
                        
                }
                .font(.headline)
                .foregroundColor(Color.red)
                
                
            }
            Spacer()
            Rectangle()
                .fill(Color.black)
                .frame(width: 40, height: 40)
                .padding(.vertical)
            
            /*
            if let profile = vm.companyProfile {
                VStack {
                    Text(profile.companyName)
                    Text(String(format: "%.2f", profile.price))
                }
                LogoView(logo: vm.companyProfile?.image ?? "")
            } else {
                ProgressView()
            }
             */
            
        }
    }
}

struct StockView_Previews: PreviewProvider {
    static var previews: some View {
        StockView(symbol: "APPL")
    }
}
