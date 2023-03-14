import Foundation
import Combine

class PriceViewModel: ObservableObject {
    @Published var stockPrice: Price?
    
    let symbol: String
    let currency: String
    
    var dataSubscription: Cancellable?
    
    init(symbol: String, currency: String) {
        self.symbol = symbol
        self.currency = currency
    }
    
    func fetchPrice() {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/quote/\(self.symbol)?apikey=d5f365f0f57c273c26a6b52b86a53010")
        else {return}
                
        dataSubscription = NetworkingManager.download(url: url)
            .decode(type: [Price].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (stockPrice) in
                self?.stockPrice = stockPrice[0]
                self?.dataSubscription?.cancel()
            })
    }
    
}

