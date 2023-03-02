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
                ChartView(symbol: vm.symbol)
                Divider()
                Group {
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
                Divider()
                newsView
                Divider()
                Text("Feed")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                //Spacer()
            }
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
            } else {
                ProgressView()
            }
        }
    }
    
    var newsView: some View {
        VStack {
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
        }
    }
}

struct StockView_Previews: PreviewProvider {
    static var previews: some View {
        StockView(symbol: "APPL")
    }
}
