import Foundation

class SearchService: SearchServiceProtocol {
    func fetchData(text: String) async -> [Search] {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/search?query=\(text)&exchange=NASDAQ,NYSE&limit=10&apikey=\(ApiKeys.financeApi)") else {return []}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let searchResult = try? decoder.decode([Search].self, from: data)
            if let searchResult = searchResult {
                return searchResult
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return []
    }
}

class MockSearchService: SearchServiceProtocol {
    var searchResults: [Search]
    
    init() {
        let search1 = Search(symbol: "AAPL", name: "Apple", currency: "USD", stockExchange: "NASDAQ", exchangeShortName: "NASDAQ")
        let search2 = Search(symbol: "MSFT", name: "Microsoft", currency: "USD", stockExchange: "NASDAQ", exchangeShortName: "NASDAQ")
        let search3 = Search(symbol: "DIS", name: "Disney", currency: "USD", stockExchange: "NYSE", exchangeShortName: "NYSE")
        let search4 = Search(symbol: "MA", name: "Mastercard", currency: "USD", stockExchange: "NYSE", exchangeShortName: "NYSE")
        
        self.searchResults = [search1, search2,search3, search4]
    }
    
    func fetchData(text: String) async -> [Search] {
        if text == "" {
            return []
        }
        else {
            return self.searchResults.filter({$0.name.hasPrefix(text)})
        }
    }
}

protocol SearchServiceProtocol {
    func fetchData(text: String) async -> [Search]
}
