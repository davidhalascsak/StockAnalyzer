import SwiftUI

struct NewAssetView: View {
    @StateObject var vm: NewAssetViewModel
    
    init(symbol: String, portfolioService: PortfolioServiceProtocol, stockService: StockServiceProtocol) {
        _vm = StateObject(wrappedValue: NewAssetViewModel(symbol: symbol, portfolioService: portfolioService, stockService: stockService))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Units:")
                Spacer()
                TextField("Units", text: $vm.units)
                    .keyboardType(.decimalPad)
                    .padding(5)
                    .frame(width: 60)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            HStack {
                Text("Date:")
                Spacer()
                DatePicker("", selection: $vm.buyDate,in: ...Date.now, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .fixedSize()
               
            }
            HStack {
                Text("Price:")
                Spacer()
                TextField("Price", text: $vm.price)
                    .keyboardType(.decimalPad)
                    .padding(5)
                    .frame(width: 60)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            .padding(.vertical, 5)
            HStack {
                Text("Total Value:")
                Spacer()
                Text("$2000")
            }
            .padding(.vertical, 5)
            HStack {
                Spacer()
                Button {
                    
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
    }
}

struct NewAssetView_Previews: PreviewProvider {
    static var previews: some View {
        NewAssetView(symbol: "AAPL", portfolioService: PortfolioService(), stockService: StockService(symbol: "AAPL") as! StockServiceProtocol)
    }
}
