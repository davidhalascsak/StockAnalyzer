import Foundation

class SearchService: SearchServiceProtocol {
    func fetchData(text: String) async -> [SearchResult] {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/search?query=\(text)&exchange=NASDAQ,NYSE&limit=10&apikey=\(ApiKeys.financeApi)") else {return []}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let searchResult = try? decoder.decode([SearchResult].self, from: data)
            
            return searchResult ?? []
        } catch {
            return []
        }
    }
}

class MockSearchService: SearchServiceProtocol {
    var db: MockDatabase = MockDatabase()
    
    func fetchData(text: String) async -> [SearchResult] {
        if text == "" {
            return []
        }
        else {
            return db.searchResult.filter({$0.name.hasPrefix(text) || $0.stockSymbol.hasPrefix(text)})
        }
    }
}

protocol SearchServiceProtocol {
    func fetchData(text: String) async -> [SearchResult]
}
