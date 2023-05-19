import SwiftUI

struct PriceView: View {
    @StateObject private var viewModel: PriceViewModel
    
    init(symbol: String, currency: String, stockService: StockServiceProtocol) {
        _viewModel = StateObject(wrappedValue: PriceViewModel(symbol: symbol, currency: currency, stockService: StockService(symbol: symbol)))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if let stockPrice = viewModel.stockPrice {
                HStack(alignment: .firstTextBaseline) {
                    Text(String(format: "%.2f", stockPrice.price))
                        .font(.title)
                        .fontWeight(.bold)
                    Text(viewModel.currency)
                        .font(.title3)
                }
                HStack(spacing: 1) {
                    Text("\(stockPrice.change > 0 ? "+" : "")\(String(format: "%.2f", stockPrice.change))")
                    Text("\(stockPrice.change > 0 ? "+" : "")(\(String(format: "%.2f", stockPrice.changeInPercentage)))%")
                }
                .font(.headline)
                .foregroundColor(stockPrice.change >= 0 ? Color.green : Color.red)
            } else {
                ProgressView()
            }
        }
        .task {
            await viewModel.fetchData()
        }
        .onReceive(viewModel.timer) { _ in
            Task {
                await viewModel.fetchData()
            }
        }
    }
}

struct PriceView_Previews: PreviewProvider {
    static var previews: some View {
        PriceView(symbol: "AAPL", currency: "USD", stockService: StockService(symbol: "AAPL"))
    }
}
