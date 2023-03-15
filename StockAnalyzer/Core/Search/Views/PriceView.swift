import SwiftUI

struct PriceView: View {
    @StateObject var vm: PriceViewModel
    
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
                HStack(spacing: 1) {
                    Text("\(stockPrice.change > 0 ? "+" : "")\(String(format: "%.2f", stockPrice.change))")
                    Text("\(stockPrice.change > 0 ? "+" : "")(\(String(format: "%.2f", stockPrice.changesPercentage)))%")
                }
                .font(.headline)
                .foregroundColor(stockPrice.change >= 0 ? Color.green : Color.red)
            } else {
                ProgressView()
            }
        }
        .onReceive(vm.timer) { _ in
            vm.fetchPrice()
        }
    }
}

struct PriceView_Previews: PreviewProvider {
    static var previews: some View {
        PriceView(symbol: "AAPL", currency: "USD")
    }
}
