import Foundation

struct Ratios: Decodable {
    let peRatioTTM: Double
    let pegRatioTTM: Double
    let priceToSalesRatioTTM: Double
    let priceToBookRatioTTM: Double
    let dividendPerShareTTM: Double
    let dividendYielPercentageTTM: Double
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
    let netIncomePerShareTTM: Double
    let freeCashFlowPerShareTTM: Double
}
