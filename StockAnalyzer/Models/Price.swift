import Foundation

struct Price: Decodable {
    let price: Double
    let changesPercentage: Double
    let change: Double
}
