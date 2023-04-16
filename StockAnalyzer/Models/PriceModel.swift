import Foundation

struct Price: Codable {
    let price: Double
    let changesPercentage: Double
    let change: Double
}

struct PriceAtDate: Codable {
    let historical: [DailyPrice]
    
    struct DailyPrice: Codable {
        let open: Double
        let close: Double
        let low: Double
        let high: Double
    }
}
