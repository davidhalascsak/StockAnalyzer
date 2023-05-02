import SwiftUI

struct NewAssetView: View {
    @StateObject var vm: NewAssetViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState var focusedField: FocusedField?
    
    init(symbol: String, portfolioService: PortfolioServiceProtocol, stockService: StockServiceProtocol) {
        _vm = StateObject(wrappedValue: NewAssetViewModel(symbol: symbol, portfolioService: portfolioService, stockService: stockService))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Units:")
                Spacer()
                TextField("Units", value: $vm.units, format: .number)
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
                DatePicker("", selection: $vm.buyDate,in: ...Date.now, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .fixedSize()
                    .onTapGesture {
                        focusedField = nil
                    }
            }
            HStack {
                Text("Price:")
                Spacer()
                TextField("Price: ", value: $vm.price, format: .number)
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
                Text(vm.value)
            }
            .padding(.vertical, 5)
            HStack {
                Spacer()
                Button {
                    Task {
                        await vm.addPositionToPortfolio()
                        if !vm.showAlert {
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
        .padding(.vertical)
        .padding(.horizontal, 50)
        .onAppear {
            Task {
                await vm.fetchPrice()
                vm.calculateValue()
            }
        }
        .onChange(of: vm.units, perform: { _ in
            vm.calculateValue()
        })
        .onChange(of: vm.price) { _ in
            vm.calculateValue()
        }
        .onChange(of: vm.buyDate) { _ in
            Task {
                await vm.fetchPrice()
                vm.calculateValue()
            }
        }
        .alert(vm.alertTitle, isPresented: $vm.showAlert) {
            Button("Ok", role: .cancel) {
                vm.alertTitle = ""
                vm.alertText = ""
            }
        } message: {
            Text(vm.alertText)
        }
    }
}

struct NewAssetView_Previews: PreviewProvider {
    static var previews: some View {
        NewAssetView(symbol: "AAPL", portfolioService: PortfolioService(), stockService: StockService(symbol: "AAPL"))
    }
}
