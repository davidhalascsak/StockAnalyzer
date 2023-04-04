import Foundation
import Combine

class StockService: ObservableObject {
    @Published var companyInformation: Company?
    
    let symbol: String
    var cancellables = Set<AnyCancellable>()
    
    init(symbol: String) {
        self.symbol = symbol
        fetchProfile()
    }
    
    func fetchProfile() {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/profile/\(self.symbol)?apikey=\(ApiKeys.financeApi)")
        else {return}
        
        
                
        NetworkingManager.download(url: url)
            .decode(type: [Company].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (companyInformation) in
                self?.companyInformation = companyInformation[0]
            })
            .store(in: &cancellables)
    }
    
    func fetchPriceAtDate(date: String) async -> Double {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/historical-price-full\(self.symbol)?from=\(date)&to=\(date)&apikey=\(ApiKeys.financeApi)") else {return 0.0}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let price = try? decoder.decode(PriceAtDate.self, from: data)
            if let price = price {
                if price.historical.count == 1 {
                    return price.historical[0].open
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return 0.0
    }
}


protocol StockServiceProtocol {
    var companyInformation: Company? { get set }
    
    func fetchProfile()
    func fetchPrice(date: String) async -> Double
}

