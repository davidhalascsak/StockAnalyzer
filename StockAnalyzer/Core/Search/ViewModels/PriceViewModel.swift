import Foundation
import Combine

class PriceViewModel: ObservableObject {
    @Published var stockPrice: Price?
    @Published var timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    let symbol: String
    let currency: String
    var counter: Int = 0
    
    var cancellables = Set<AnyCancellable>()
    
    init(symbol: String, currency: String) {
        self.symbol = symbol
        self.currency = currency
        fetchData()
    }
    
    func fetchData() {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/quote/\(self.symbol)?apikey=\(ApiKeys.financeApi)")
        else {return}
        
        NetworkingManager.download(url: url)
            .decode(type: [Price].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (stockPrice) in
                self?.stockPrice = stockPrice[0]
            })
            .store(in: &cancellables)
    }
}

