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
        guard let url = URL(string:  "https://financialmodelingprep.com/api/v3/profile/\(self.symbol)?apikey=d5f365f0f57c273c26a6b52b86a53010")
        else {return}
                
        dataSubscription = NetworkingManager.download(url: url)
            .decode(type: [Company].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (companyInformation) in
                self?.companyInformation = companyInformation[0]
                self?.dataSubscription?.cancel()
            })
    }
    
    // getFinancialData()
    // getDividendData()
    // getBalanceSheet()
    // ...
}

struct Company: Codable {
    let symbol: String
    let price: Double
    let changes: Double
    let companyName: String
    let currency: String
    let industry: String
    let description: String
    let ceo: String
    let sector: String
    let country: String
    let fullTimeEmployees: String
    let city: String
    let state: String
    let image: String
}

