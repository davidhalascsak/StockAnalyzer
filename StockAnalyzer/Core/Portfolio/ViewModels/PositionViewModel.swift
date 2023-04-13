import Foundation
import UIKit

@MainActor
class PositionViewModel: ObservableObject {
    @Published var companyProfile: Company?
    @Published var logo: UIImage?
    @Published var isLoading: Bool = false
    
    let asset: Asset
    let stockService: StockServiceProtocol
    let imageService: ImageServiceProtocol
    
    init(asset: Asset, stockService: StockServiceProtocol, imageService: ImageServiceProtocol) {
        self.asset = asset
        self.stockService = stockService
        self.imageService = imageService
    }
    
    func fetchData() async {
        self.companyProfile = await self.stockService.fetchProfile()
        if let companyProfile = self.companyProfile {
            self.logo = await self.imageService.fetchData(url: companyProfile.image)
        }
        self.isLoading = false
    }
    
    func changeInPrice() -> String {
        if let price = self.companyProfile?.price, let change = self.companyProfile?.changes {
            let changeInPercentage = String(format: "%.2f", (change / (price + change)) * 100)
            
            return "\(String(format: "%.2f", change))(\(changeInPercentage)%)"
        }
        else {
            return "0.0(0.0%)"
        }
    }
    
    func deletePosition(at index: Int) async {
        
    }
}
