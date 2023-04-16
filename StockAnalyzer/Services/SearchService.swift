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

protocol SearchServiceProtocol {
    func fetchData(text: String) async -> [Search]
}
