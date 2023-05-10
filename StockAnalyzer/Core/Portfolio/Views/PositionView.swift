import SwiftUI

struct PositionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var vm: PositionViewModel
    
    init(asset: Asset, stockService: StockServiceProtocol, portfolioService: PortfolioServiceProtocol, imageService: ImageServiceProtocol) {
        _vm = StateObject(wrappedValue: PositionViewModel(asset: asset, stockService: stockService, portfolioService: PortfolioService(), imageService: imageService))
    }
    
    var body: some View {
        VStack {
            if vm.isLoading == false {
                HStack(alignment: .top) {
                    ImageView(url: vm.companyProfile?.image ?? "", defaultImage: "", imageService: ImageService())
                        .scaledToFit()
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .frame(height: 50)
                        .frame(maxWidth: 50)
                    NavigationLink {
                        StockView(symbol: vm.asset.symbol, stockService: StockService(symbol: vm.asset.symbol), sessionService: SessionService())
                    } label: {
                        VStack(alignment: .leading) {
                            Text(vm.asset.symbol)
                                .fontWeight(.semibold)
                            Text(vm.companyProfile?.companyName ?? "")
                                .multilineTextAlignment(.leading)
                        }
                    }.id(UUID())
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(String(format: "%.2f", vm.price?.price ?? 0.0))
                            .fontWeight(.semibold)
                        Text(vm.changeInPrice())
                            .foregroundColor(vm.price?.change ?? 0 > 0 ? Color.green : vm.companyProfile?.changes ?? 0 == 0 ? Color.black : Color.red)
                    }
                }
                .foregroundColor(Color.primary)
                .padding()
                Divider()
                positions
            } else {
                ProgressView()
            }
        }
        .task {
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
            ToolbarItem(placement: .navigationBarTrailing) {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.title2)
                    .onTapGesture {
                        vm.isLoading = true
                        Task {
                            await vm.reloadAsset()
                        }
                    }
                    .disabled(vm.isLoading)
                    .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)
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
                    if let viewModel = vm.positionViewModels[position.id ?? ""] {
                        PositionRowView(viewModel: viewModel)
                            .alignmentGuide(.listRowSeparatorLeading) { dimension in
                                dimension[.leading]
                            }
                            .listRowInsets(EdgeInsets())
                    }
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
                if vm.asset.positionCount == 0 {
                    dismiss()
                }
            }
        }
    }
}

 struct PositionView_Previews: PreviewProvider {
     static let position1 = Position( date: "2020-02-02", units: 2.0, price: 132.5)
     static let position2 = Position( date: "2020-02-02", units: 3.0, price: 230.0)
     static let asset = Asset(symbol: "AAPL", units: 2.0, averagePrice: 132.5,  positionCount: 2, positions: [position1, position2])
     
     static var previews: some View {
         PositionView(asset: asset, stockService: StockService(symbol: "AAPL"), portfolioService: PortfolioService(), imageService: ImageService())
     }
 }
 
