import Foundation

struct Search: Codable, Hashable  {
    let symbol: String
    let name: String
    let currency: String?
    let stockExchange: String
    let exchangeShortName: String
}
