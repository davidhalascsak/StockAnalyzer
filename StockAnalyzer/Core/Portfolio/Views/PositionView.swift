import SwiftUI

struct PositionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var vm: PositionViewModel
    
    init(asset: Asset, stockService: StockServiceProtocol, imageService: ImageServiceProtocol) {
        _vm = StateObject(wrappedValue: PositionViewModel(asset: asset, stockService: stockService, imageService: imageService))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if vm.isLoading == false {
                HStack(alignment: .top) {
                    if let logo = vm.logo {
                        Image(uiImage: logo)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .cornerRadius(10)
                    } else {
                        Rectangle()
                            .frame(width: 60, height: 60)
                            .cornerRadius(10)
                    }
                    VStack(alignment: .leading) {
                        Text(vm.asset.symbol)
                            .fontWeight(.semibold)
                        Text(vm.companyProfile?.companyName ?? "")
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(String(format: "%.2f", vm.companyProfile?.price ?? 0.0))
                            .fontWeight(.semibold)
                        Text(vm.changeInPrice())
                            .foregroundColor(vm.companyProfile?.changes ?? 0 > 0 ? Color.green : vm.companyProfile?.changes ?? 0 == 0 ? Color.black : Color.red)
                    }
                }
                .padding()
                Divider()
                positions
                
            } else {
                ProgressView()
            }
        }
        .task {
            vm.isLoading = true
            await vm.fetchData()
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Image(systemName: "arrowshape.backward")
                    .onTapGesture {
                        dismiss()
                    }
            }
        }
    }
    
    var positions: some View {
        VStack {
            HStack(spacing: 20) {
                Text("Units")
                Spacer()
                Text("Invested")
                Spacer()
                Text("P / L")
                Spacer()
                Text("Value")
            }
            .padding(.horizontal)
            Divider()
            List {
                ForEach(vm.asset.positions ?? [], id: \.self) { position in
                    PositionRowView(position: position, stockService: StockService(symbol: position.symbol))
                        .alignmentGuide(.listRowSeparatorLeading) { dimension in
                            dimension[.leading]
                        }
                        .listRowInsets(EdgeInsets())
                }
                .onDelete(perform: delete)
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .padding(.top, -8)
        }
    }
    
    func delete(at offsets: IndexSet) {
        let index = offsets.first ?? nil
        if let index = index {
            Task {
                await vm.deletePosition(at: index)
            }
        }
    }
}

 struct PositionView_Previews: PreviewProvider {
     static let position1 = Position(symbol: "AAPL", date: "2020-02-02", units: 2.0, price: 132.5, investedAmount: 265.0)
     static let position2 = Position(symbol: "MSFT", date: "2020-02-02", units: 3.0, price: 230.0, investedAmount: 690.0)
     static let asset = Asset(symbol: "AAPL", units: 2.0, averagePrice: 132.5, investedAmount: 265.0, positions: [position1, position2])
     
     static var previews: some View {
         PositionView(asset: asset, stockService: StockService(symbol: "AAPL"), imageService: ImageService())
     }
 }
 
