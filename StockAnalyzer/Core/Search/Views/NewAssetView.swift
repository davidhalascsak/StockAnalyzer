import SwiftUI

struct NewAssetView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: FocusField?
    
    @StateObject private var viewModel: NewAssetViewModel
    
    private enum FocusField {
        case unitField
        case priceField
    }
    
    init(stockSymbol: String, portfolioService: PortfolioServiceProtocol, stockService: StockServiceProtocol) {
        _viewModel = StateObject(wrappedValue: NewAssetViewModel(stockSymbol: stockSymbol, portfolioService: portfolioService, stockService: stockService))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            newAssetView
        }
        .padding(.vertical)
        .padding(.horizontal, 50)
        .onAppear {
            Task {
                await viewModel.fetchPrice()
                viewModel.calculateValue()
            }
        }
        .onChange(of: viewModel.units, perform: { _ in
            viewModel.calculateValue()
        })
        .onChange(of: viewModel.price) { _ in
            viewModel.calculateValue()
        }
        .onChange(of: viewModel.buyDate) { _ in
            Task {
                await viewModel.fetchPrice()
                viewModel.calculateValue()
            }
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button("Ok", role: .cancel) {
                viewModel.alertTitle = ""
                viewModel.alertText = ""
            }
        } message: {
            Text(viewModel.alertText)
        }
    }
    
    var newAssetView: some View {
        VStack {
            HStack {
                Text("Units:")
                Spacer()
                TextField("Units", value: $viewModel.units, format: .number)
                    .keyboardType(.decimalPad)
                    .focused($focusedField, equals: .unitField)
                    .padding(5)
                    .frame(width: 80)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            HStack {
                Text("Date:")
                Spacer()
                DatePicker("", selection: $viewModel.buyDate,in: ...Date.now, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .fixedSize()
                    .onTapGesture {
                        focusedField = nil
                    }
            }
            HStack {
                Text("Price:")
                Spacer()
                TextField("Price: ", value: $viewModel.price, format: .number)
                    .keyboardType(.decimalPad)
                    .focused($focusedField, equals: .priceField)
                    .padding(5)
                    .frame(width: 80)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            .padding(.vertical, 5)
            HStack {
                Text("Total Value:")
                Spacer()
                Text(viewModel.value)
            }
            .padding(.vertical, 5)
            HStack {
                Spacer()
                Button {
                    Task {
                        await viewModel.addPositionToPortfolio()
                        if !viewModel.showAlert {
                            dismiss()
                        }
                    }
                } label: {
                    Text("Add")
                        .foregroundColor(Color.white)
                        .font(.headline)
                        .padding(10)
                        .frame(width: 100)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                Spacer()
                
            }
        }
    }
}

struct NewAssetView_Previews: PreviewProvider {
    static var previews: some View {
        NewAssetView(stockSymbol: "AAPL", portfolioService: PortfolioService(), stockService: StockService(stockSymbol: "AAPL"))
    }
}
