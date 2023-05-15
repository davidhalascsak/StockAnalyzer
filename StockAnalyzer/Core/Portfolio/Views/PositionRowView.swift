import SwiftUI

struct PositionRowView: View {
    @StateObject var viewModel: PositionRowViewModel
    
    init(viewModel: PositionRowViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            if !viewModel.isLoading {
                HStack {
                    Text(String(format: "%.2f", viewModel.position.units))
                    Spacer()
                    Text("$\(String(format: "%.2f", viewModel.position.investedAmount))")
                    Spacer()
                    Text(viewModel.difference.formatedValue)
                        .foregroundColor(viewModel.difference >= 0 ? Color.green : Color.red)
                    Spacer()
                    Text(viewModel.currentValue.formatedValue)
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

struct PositionRowView_Previews: PreviewProvider {
    static let position = Position(date: "2020-02-02", units: 2.0, price: 132.5)
    static var previews: some View {
        PositionRowView(viewModel: PositionRowViewModel(position: position, stockService: StockService(symbol: "AAPL")))
    }
}
