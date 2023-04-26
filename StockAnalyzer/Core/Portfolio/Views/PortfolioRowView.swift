import SwiftUI

struct PortfolioRowView: View {
    @StateObject var vm: PortfolioRowViewModel
    
    init(viewModel: PortfolioRowViewModel) {
        _vm = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            if vm.isLoading == false {
                HStack {
                    Text(vm.asset.symbol)
                        .font(.headline)
                    Spacer()
                    Text("$\(String(format: "%.2f", vm.asset.investedAmount))")
                    Spacer()
                    Text(vm.formatValue(value: vm.difference))
                        .foregroundColor(vm.difference >= 0 ? Color.green : Color.red)
                    Spacer()
                    Text("$\(String(format: "%.2f", vm.currentValue))")
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
    static let asset = Asset(symbol: "Apple", units: 1.00, averagePrice: 132.00, investedAmount: 160.00, positionCount: 1)
    static var previews: some View {
        PortfolioRowView(viewModel: PortfolioRowViewModel(asset: asset, stockService: StockService(symbol: asset.symbol)))
    }
}
