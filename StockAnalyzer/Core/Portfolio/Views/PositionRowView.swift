import SwiftUI

struct PositionRowView: View {
    @StateObject var vm: PositionRowViewModel
    
    init(viewModel: PositionRowViewModel) {
        _vm = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            if vm.isLoading == false {
                HStack {
                    Text(String(format: "%.2f", vm.position.units))
                    Spacer()
                    Text("$\(String(format: "%.2f", vm.position.investedAmount))")
                    Spacer()
                    Text(vm.toString(value: vm.difference))
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
        .task {
            vm.isLoading = true
            await vm.fetchPrice()
            vm.calculateCurrentValue()
            vm.isLoading = false
        }
    }
}

struct PositionRowView_Previews: PreviewProvider {
    static let position = Position(symbol: "AAPL", date: "2020-02-02", units: 2.0, price: 132.5, investedAmount: 265.0)
    static var previews: some View {
        PositionRowView(viewModel: PositionRowViewModel(position: position, stockService: StockService(symbol: position.symbol)))
    }
}
