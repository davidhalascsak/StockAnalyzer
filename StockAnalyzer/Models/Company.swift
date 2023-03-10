import Foundation

struct Company: Codable {
    let symbol: String
    let price: Double
    let changes: Double
    let exchangeShortName: String
    let companyName: String
    let currency: String
    let industry: String
    let description: String
    let ceo: String
    let sector: String
    let country: String
    let fullTimeEmployees: String
    let city: String
    let state: String?
    let image: String
}
