import SwiftUI

struct PriceView: View {
    @StateObject var vm: PriceViewModel
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(symbol: String, currency: String) {
        _vm = StateObject(wrappedValue: PriceViewModel(symbol: symbol, currency: currency))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if let stockPrice = vm.stockPrice {
                HStack(alignment: .firstTextBaseline) {
                    Text(String(format: "%.2f", stockPrice.price))
                        .font(.title)
                        .fontWeight(.bold)
                    Text(vm.currency)
                        .font(.title3)
                }
                HStack {
                    Text("\(stockPrice.price >= 0 ? "+" : "")\(String(format: "%.2f", stockPrice.change))")
                    Text("(\(String(format: "%.2f", stockPrice.changesPercentage))%")
                }
                .font(.headline)
                .foregroundColor(stockPrice.change >= 0 ? Color.green : Color.red)
            } else {
                ProgressView()
            }
        }
        .onReceive(timer) { _ in
            vm.fetchPrice()
        }
        .onDisappear(perform: timer.upstream.connect().cancel)
    }
}

struct PriceView_Previews: PreviewProvider {
    static var previews: some View {
        PriceView(symbol: "AAPL", currency: "USD")
    }
}
