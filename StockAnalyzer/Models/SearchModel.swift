import Foundation

struct SearchResult: Codable, Hashable  {
    let stockSymbol: String
    let name: String
    let exchangeShortName: String
    
    enum CodingKeys: String, CodingKey {
        case stockSymbol = "symbol"
        case name
        case exchangeShortName
    }
}
