import Foundation
import Combine

class PriceViewModel: ObservableObject {
    @Published var stockPrice: Price?
    @Published var timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    let symbol: String
    let currency: String
    var counter: Int = 0
    
    private var priceSubscription: AnyCancellable?
    
    init(symbol: String, currency: String) {
        self.symbol = symbol
        self.currency = currency
        fetchPrice()
    }
    
    func fetchPrice() {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/quote/\(self.symbol)?apikey=\(ApiKeys.financeApi)")
        else {return}
        
        priceSubscription = NetworkingManager.download(url: url)
            .decode(type: [Price].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (stockPrice) in
                self?.stockPrice = stockPrice[0]
                self?.priceSubscription?.cancel()
            })
    }
}

