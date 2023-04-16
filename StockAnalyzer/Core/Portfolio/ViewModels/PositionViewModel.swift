import Foundation
import UIKit

@MainActor
class PositionViewModel: ObservableObject {
    @Published var companyProfile: Company?
    @Published var price: Price?
    @Published var logo: UIImage?
    @Published var isLoading: Bool = false
    @Published var positionViewModels: [String: PositionRowViewModel] = [:]
    
    let asset: Asset
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
        self.companyProfile = await self.stockService.fetchProfile()
        self.price = await self.stockService.fetchPriceInRealTime()
        
        if let companyProfile = self.companyProfile {
            self.logo = await self.imageService.fetchData(url: companyProfile.image)
        }
        
        for position in asset.positions ?? [] {
            let vm = PositionRowViewModel(position: position, stockService: StockService(symbol: position.symbol))
            positionViewModels[asset.symbol] = vm
        }
    }
    
    func changeInPrice() -> String {
        if let price = self.price?.price, let change = self.price?.change {
            let changeInPercentage = String(format: "%.2f", (change / (price + change)) * 100)
            
            return "\(String(format: "%.2f", change))(\(changeInPercentage)%)"
        }
        else {
            return "0.0(0.0%)"
        }
    }
    
    func reloadAsset() async {
        self.price = await self.stockService.fetchPriceInRealTime()
        
        for position in self.asset.positions ?? [] {
            if let vm = positionViewModels[position.symbol] {
                await vm.updatePrice()
            }
        }
    }
    
    func deletePosition(at index: Int) async {
        let position = self.asset.positions?[index]
        
        if let position = position {
            await self.portfolioService.deletePosition(asset: asset, position: position)
        }
    }
}
