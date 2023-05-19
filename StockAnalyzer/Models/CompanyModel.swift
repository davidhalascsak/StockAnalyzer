import Foundation

struct CompanyProfile: Codable {
    let symbol: String
    let price: Double
    let changes: Double
    let currency: String
    let exchangeShortName: String
    let companyName: String
    let description: String
    let fullTimeEmployees: String
    let industry: String
    let sector: String
    let ceo: String
    let country: String
    let state: String?
    let city: String
    let image: String
}
