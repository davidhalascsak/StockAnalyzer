import Foundation

struct CompanyProfile: Codable {
    let stockSymbol: String
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
    
    enum CodingKeys: String, CodingKey {
        case stockSymbol = "symbol"
        case price
        case changes
        case currency
        case exchangeShortName
        case companyName
        case description
        case fullTimeEmployees
        case industry
        case sector
        case ceo
        case country
        case state
        case city
        case image
    }
}
