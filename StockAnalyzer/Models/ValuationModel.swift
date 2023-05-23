import Foundation

struct Ratios: Decodable {
    let peRatio: Double
    let pegRatio: Double
    let priceToSalesRatio: Double
    let priceToBookRatio: Double
    let dividendPerShare: Double
    let dividendYieldPercentage: Double
    
    enum CodingKeys: String, CodingKey {
        case peRatio = "peRatioTTM"
        case pegRatio = "pegRatioTTM"
        case priceToSalesRatio = "priceToSalesRatioTTM"
        case priceToBookRatio = "priceToBookRatioTTM"
        case dividendPerShare = "dividendPerShareTTM"
        case dividendYieldPercentage = "dividendYielPercentageTTM"
    }
}

struct GrowthRates: Decodable {
    let netIncomeGrowth: Double
    let freeCashFlowGrowth: Double
    let weightedAverageSharesGrowth: Double
}

struct MarketCap: Decodable {
    let marketCap: Int
}

struct Metrics: Decodable {
    let netIncomePerShare: Double
    let freeCashFlowPerShare: Double
    
    enum CodingKeys: String, CodingKey {
        case netIncomePerShare = "netIncomePerShareTTM"
        case freeCashFlowPerShare = "freeCashFlowPerShareTTM"
    }
}
