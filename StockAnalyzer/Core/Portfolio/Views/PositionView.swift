import SwiftUI

struct PositionView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var viewModel: PositionViewModel
    
    init(asset: Asset, stockService: StockServiceProtocol, portfolioService: PortfolioServiceProtocol, imageService: ImageServiceProtocol) {
        _viewModel = StateObject(wrappedValue: PositionViewModel(asset: asset, stockService: stockService, portfolioService: PortfolioService(), imageService: imageService))
    }
    
    var body: some View {
        VStack {
            if !viewModel.isLoading {
                headerView
                Divider()
                positionsView
            } else {
                ProgressView()
            }
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
                        viewModel.isLoading = true
                        Task {
                            await viewModel.reloadAsset()
                        }
                    }
                    .disabled(viewModel.isLoading)
                    .rotationEffect(Angle(degrees: viewModel.isLoading ? 360 : 0), anchor: .center)
            }
        }
        .task {
            viewModel.isLoading = true
            await viewModel.fetchData()
        }
    }
    
    var headerView: some View {
        HStack(alignment: .top) {
            ImageView(url: viewModel.companyProfile?.image ?? "", defaultImage: "", imageService: ImageService())
                .scaledToFit()
                .cornerRadius(10)
                .shadow(radius: 5)
                .frame(height: 50)
                .frame(maxWidth: 50)
            NavigationLink {
                StockView(symbol: viewModel.asset.stockSymbol, stockService: StockService(symbol: viewModel.asset.stockSymbol), sessionService: SessionService())
            } label: {
                VStack(alignment: .leading) {
                    Text(viewModel.asset.stockSymbol)
                        .fontWeight(.semibold)
                    Text(viewModel.companyProfile?.companyName ?? "")
                        .multilineTextAlignment(.leading)
                }
            }.id(UUID())
            Spacer()
            VStack(alignment: .trailing) {
                Text(String(format: "%.2f", viewModel.price?.price ?? 0.0))
                    .fontWeight(.semibold)
                Text("\(viewModel.price?.change ?? 0.0)(\(viewModel.price?.changeInPercentage ?? 0.0))")
                    .foregroundColor(viewModel.price?.change ?? 0 > 0 ? Color.green : viewModel.companyProfile?.changes ?? 0 == 0 ? Color.black : Color.red)
            }
        }
        .foregroundColor(Color.primary)
        .padding()
    }
    
    var positionsView: some View {
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
                ForEach(viewModel.asset.positions ?? [], id: \.self) { position in
                    if let viewModel = viewModel.positionViewModels[position.id ?? ""] {
                        PositionRowView(viewModel: viewModel)
                            .alignmentGuide(.listRowSeparatorLeading) { dimension in
                                dimension[.leading]
                            }
                            .listRowInsets(EdgeInsets())
                    }
                }
                .onDelete { indexSet in
                    Task {
                        await viewModel.deletePosition(at: indexSet)
                        if viewModel.asset.positionCount == 0 {
                            dismiss()
                        }
                    }
                }
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .padding(.top, -8)
        }
    }
}

 struct PositionView_Previews: PreviewProvider {
     static let position1 = Position( date: "2020-02-02", units: 2.0, price: 132.5)
     static let position2 = Position( date: "2020-02-02", units: 3.0, price: 230.0)
     static let asset = Asset(stockSymbol: "AAPL", units: 2.0, averagePrice: 132.5,  positionCount: 2, positions: [position1, position2])
     
     static var previews: some View {
         PositionView(asset: asset, stockService: StockService(symbol: "AAPL"), portfolioService: PortfolioService(), imageService: ImageService())
     }
 }
 
