import SwiftUI

struct PortfolioRowView: View {
    @StateObject var viewModel: PortfolioRowViewModel
    
    init(viewModel: PortfolioRowViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading == false {
                HStack {
                    Text(viewModel.asset.stockSymbol)
                        .font(.headline)
                    Spacer()
                    Text("$\(String(format: "%.2f", viewModel.asset.investedAmount))")
                    Spacer()
                    Text(viewModel.difference.formattedPrice)
                        .foregroundColor(viewModel.difference >= 0 ? Color.green : Color.red)
                    Spacer()
                    Text(viewModel.currentValue.formattedPrice)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
            }
            else {
                ProgressView()
            }
        }
    }
}

struct PortfolioRowView_Previews: PreviewProvider {
    static let asset = Asset(stockSymbol: "Apple", units: 1.00, averagePrice: 132.00, positionCount: 1)
    static var previews: some View {
        PortfolioRowView(viewModel: PortfolioRowViewModel(asset: asset, stockService: StockService(stockSymbol: asset.stockSymbol)))
    }
}
