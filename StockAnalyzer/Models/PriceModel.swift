import Foundation

struct CurrentPrice: Codable {
    let price: Double
    let change: Double
    let changeInPercentage: Double
    
    enum CodingKeys: String, CodingKey {
        case price
        case change
        case changeInPercentage = "changesPercentage"
    }
}

struct PriceInterval: Codable {
    let historical: [HistoricalPrice]
}

struct HistoricalPrice: Codable {
    let date: String
    let open: Double
    let close: Double
}
