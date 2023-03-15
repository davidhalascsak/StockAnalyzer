import Foundation
import Combine

class StockService: ObservableObject {
    @Published var companyInformation: Company?
    
    let symbol: String
    var dataSubscription: AnyCancellable?
    
    init(symbol: String) {
        self.symbol = symbol
        getCompanyData()
    }
    
    func getCompanyData() {
        guard let url = URL(string:  "https://financialmodelingprep.com/api/v3/profile/\(self.symbol)?apikey=\(ApiKeys.financeApi)")
        else {return}
                
        dataSubscription = NetworkingManager.download(url: url)
            .decode(type: [Company].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (companyInformation) in
                self?.companyInformation = companyInformation[0]
                self?.dataSubscription?.cancel()
            })
    }
}

