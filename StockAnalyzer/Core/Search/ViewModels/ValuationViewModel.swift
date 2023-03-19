import Foundation
import Combine

class ValuationViewModel: ObservableObject {
    @Published var ratios: Ratios?
    @Published var marketCap: MarketCap?
    
    var cancellables = Set<AnyCancellable>()
    
    let company: Company
    
    init(company: Company) {
        self.company = company
        fetchMarketCap()
        fetchRatios()
    }
    
    func fetchMarketCap() {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/market-capitalization/\(company.symbol)?apikey=\(ApiKeys.financeApi)") else {return}
                
        NetworkingManager.download(url: url)
            .decode(type: [MarketCap].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] enterpriseValue in
                self?.marketCap = enterpriseValue[0]
            }
            .store(in: &cancellables)
    }
    
    func fetchRatios() {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/ratios-ttm/\(company.symbol)?apikey=\(ApiKeys.financeApi)") else {return}
                
        NetworkingManager.download(url: url)
            .decode(type: [Ratios].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] metrics in
                self?.ratios = metrics[0]
            }
            .store(in: &cancellables)
    }
    
    func formatPrice(price: Int) -> String {
        let priceAsString: String = String(price)
        var result: String
        
        if priceAsString.count % 3 == 0 {
            result = "\(priceAsString[0...2]).\(priceAsString[3...5])"
        } else if priceAsString.count % 3 == 1 {
            result = "\(priceAsString[0]).\(priceAsString[1...3])"
        } else {
            result = "\(priceAsString[0...1]).\(priceAsString[2...4])"
        }
        
        if priceAsString.count < 10 {
            result.append("M")
        } else if 10 <= priceAsString.count && priceAsString.count < 13 {
            result.append("B")
        } else {
            result.append("T")
        }
        
        return result
    }
}

struct Ratios: Decodable {
    let peRatioTTM: Double
    let pegRatioTTM: Double
    let priceToSalesRatioTTM: Double
    let priceToBookRatioTTM: Double
    let dividendPerShareTTM: Double
    let dividendYielPercentageTTM: Double
}

struct MarketCap: Decodable {
    let marketCap: Int
}
