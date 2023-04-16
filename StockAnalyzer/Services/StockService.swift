import Foundation
import Combine


class StockService: StockServiceProtocol {
    let symbol: String
    
    init(symbol: String) {
        self.symbol = symbol
    }
    
    func fetchProfile() async -> Company? {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/profile/\(self.symbol)?apikey=\(ApiKeys.financeApi)")
        else {return nil}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let company = try? decoder.decode([Company].self, from: data)
            if let company = company {
                return company[0]
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    func fetchPriceInRealTime() async -> Price? {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/quote/\(self.symbol)?apikey=\(ApiKeys.financeApi)")
        else {return nil}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let price = try? decoder.decode([Price].self, from: data)
           
            if let price = price {
                return price[0]
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    func fetchPriceAtDate(date: String) async -> Double {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/historical-price-full/\(self.symbol)?from=\(date)&to=\(date)&apikey=\(ApiKeys.financeApi)") else {return 0.0}
        
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
    func fetchProfile() async -> Company?
    func fetchPriceInRealTime() async -> Price?
    func fetchPriceAtDate(date: String) async -> Double
}

