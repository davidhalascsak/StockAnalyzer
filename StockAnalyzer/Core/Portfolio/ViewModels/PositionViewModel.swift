import Foundation
import UIKit

@MainActor
class PositionViewModel: ObservableObject {
    @Published var companyProfile: Company?
    @Published var price: Price?
    @Published var isLoading: Bool = false
    @Published var positionViewModels: [String: PositionRowViewModel] = [:]
    
    var asset: Asset
    let stockService: StockServiceProtocol
    let imageService: ImageServiceProtocol
    let portfolioService: PortfolioServiceProtocol
    
    init(asset: Asset, stockService: StockServiceProtocol,portfolioService: PortfolioServiceProtocol, imageService: ImageServiceProtocol) {
        self.asset = asset
        self.stockService = stockService
        self.portfolioService = portfolioService
        self.imageService = imageService
    }
    
    func fetchData() async {
        companyProfile = await stockService.fetchProfile()
        price = await stockService.fetchPriceInRealTime()
        
        for position in asset.positions ?? [] {
            let vm = PositionRowViewModel(position: position, stockService: StockService(symbol: asset.symbol))
            positionViewModels[position.id ?? ""] = vm
            await vm.calculateCurrentValue()
        }
        
        isLoading = false
    }
    
    func reloadAsset() async {
        price = await stockService.fetchPriceInRealTime()
        for _ in asset.positions ?? [] {
            if let vm = positionViewModels[asset.symbol] {
                await vm.calculateCurrentValue()
            }
        }
        isLoading = false
    }
    
    func deletePosition(at offsets: IndexSet) async {
        let index = offsets.first ?? nil
        if let index = index {
            Task {
                let position = asset.positions?[index]
                
                if let position = position {
                    let result = await portfolioService.deletePosition(asset: asset, position: position)
                    if result {
                        asset.positions?.remove(at: index)
                        positionViewModels.removeValue(forKey: position.id ?? "")
                        asset.positionCount -= 1
                    }
                }
            }
        }
    }
}
