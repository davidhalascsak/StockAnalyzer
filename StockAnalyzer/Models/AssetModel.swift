import Foundation

struct Asset: Hashable, Codable {
    let symbol: String
    let units: Double
    let averagePrice: Double
    let investedAmount: Double
    
    var positions: [Position]?
}

struct Position: Hashable, Codable {
    let symbol: String
    let date: String
    let units: Double
    let price: Double
    let investedAmount: Double
}
