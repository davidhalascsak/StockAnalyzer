import SwiftUI

struct StockView: View {
    @StateObject var vm: StockViewModel
    @State var isExpanded: Bool = false
    
    init(symbol: String) {
        _vm = StateObject(wrappedValue: StockViewModel(symbol: symbol))
    }
    
    var body: some View {
        
        if vm.companyProfile != nil {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    header
                        .padding()
                    Divider()
                    ChartView(symbol: vm.symbol)
                        .padding(.bottom, 2.0)
                    descriptionView
                    newsView
                    Text("Feed")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                }
            }
        } else {
            ProgressView()
        }
        
    }
    
    var header: some View {
        HStack(alignment: .top) {
            if let profile = vm.companyProfile {
                VStack(alignment: .leading) {
                    Text(profile.companyName)
                        .font(.title)
                        .fontWeight(.bold)
                    Text(profile.sector)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(3)
                        .padding(.horizontal, 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    HStack(alignment: .firstTextBaseline) {
                        Text(String(format: "%.2f", profile.price))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text(profile.currency)
                            .font(.title2)
                    }
                    HStack {
                        Text("\(profile.changes >= 0 ? "+" : "")\(String(format: "%.2f", profile.changes))")
                        Text("(\(vm.decreaseInPercentage(price: profile.price, change: profile.changes))%)")
                    }
                    .font(.headline)
                    .foregroundColor(profile.changes >= 0 ? Color.green : Color.red)
                }
                Spacer()
                LogoView(logo: profile.image)
            }
        }
    }
    
    var descriptionView: some View {
        VStack(alignment: .leading) {
            Text("About")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal)
                .padding(.bottom, 2)
            VStack {
                Text(vm.companyProfile?.description ?? "")
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
        }
    }
    
    var newsView: some View {
        VStack(alignment: .leading) {
            if vm.isDownloadingNews == true {
                ProgressView()
            } else {
                Text("News")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                
                if vm.news.count > 0 {
                    TabView {
                        ForEach(vm.news, id: \.self) { news in
                            if let link = URL(string: news.link) {
                                Link(destination: link) {
                                    VStack {
                                        Text(news.title)
                                            .foregroundColor(Color.white)
                                            .lineLimit(3)
                                        Text(news.pubDate)
                                            .foregroundColor(Color.white)
                                            .font(.headline)
                                    }
                                    .padding()
                                    .frame(height: 200)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.black)
                                    .cornerRadius(10)
                                    .padding()
                                }
                            }
                        }
                    }
                    .frame(height: 200)
                    .tabViewStyle(.page)
                }
            }
        }
    }
}

struct StockView_Previews: PreviewProvider {
    static var previews: some View {
        StockView(symbol: "APPL")
    }
}
