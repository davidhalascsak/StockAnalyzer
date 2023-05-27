import Foundation


class StockService: StockServiceProtocol {
    let stockSymbol: String
    
    init(stockSymbol: String) {
        self.stockSymbol = stockSymbol
    }
    
    func fetchProfile() async -> CompanyProfile? {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/profile/\(stockSymbol)?apikey=\(ApiKeys.financeApi)")
        else {return nil}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let company = try? decoder.decode([CompanyProfile].self, from: data)
            
            return company?[0] ?? nil
        } catch {
            return nil
        }
    }
    
    func fetchPriceInRealTime() async -> CurrentPrice? {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/quote/\(stockSymbol)?apikey=\(ApiKeys.financeApi)")
        else {return nil}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let price = try? decoder.decode([CurrentPrice].self, from: data)
           
            return price?[0] ?? nil
        } catch {
            return nil
        }
    }
    
    func fetchPriceAtDate(date: String) async -> Double {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/historical-price-full/\(stockSymbol)?from=\(date)&to=\(date)&apikey=\(ApiKeys.financeApi)") else {return 0.0}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let price = try? decoder.decode(PriceInterval.self, from: data)
           
            if let price = price {
                if price.historical.count == 1 {
                    return price.historical[0].open
                }
            }
            return 0.0
        } catch {
            return 0.0
        }
    }
    
    func fetchMarketCap() async -> Int {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/market-capitalization/\(stockSymbol)?apikey=\(ApiKeys.financeApi)") else {return 0}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let marketCap = try? decoder.decode([MarketCap].self, from: data)
           
            return marketCap?[0].marketCap ?? 0
        } catch {
            return 0
        }
    }
    
    func fetchRatios() async -> Ratios? {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/ratios-ttm/\(stockSymbol)?apikey=\(ApiKeys.financeApi)") else {return nil}
                
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let ratios = try? decoder.decode([Ratios].self, from: data)
           
            return ratios?[0] ?? nil
        } catch {
            return nil
        }
    }
    
    func fetchGrowthRates() async -> GrowthRates? {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/financial-growth/\(stockSymbol)?limit=1&apikey=\(ApiKeys.financeApi)") else {return nil}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let growthRates = try? decoder.decode([GrowthRates].self, from: data)
           
            return growthRates?[0] ?? nil
        } catch {
            return nil
        }
    }
    
    func fetchMetrics() async -> Metrics? {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/key-metrics-ttm/\(stockSymbol)?limit=1&apikey=\(ApiKeys.financeApi)") else {return nil}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let metrics = try? decoder.decode([Metrics].self, from: data)
           
            return metrics?[0] ?? nil
        } catch {
            return nil
        }
    }
}

class MockStockService: StockServiceProtocol {
    let db = MockDatabase()
    let stockSymbol: String
    
    init(stockSymbol: String) {
        self.stockSymbol = stockSymbol
    }
    
    func fetchProfile() async -> CompanyProfile? {
        return  db.profiles[stockSymbol]
    }
    
    func fetchPriceInRealTime() async -> CurrentPrice? {
        return db.currentPrices[stockSymbol]
    }
    
    func fetchPriceAtDate(date: String) async -> Double {
        if date != "2022-01-22" {
            return 0.00
        } else {
            return 110.00
        }
    }
    
    func fetchMarketCap() async -> Int {
        if stockSymbol != "AAPL" {
            return 0
        } else {
            return 10000000
        }
    }
    
    func fetchRatios() async -> Ratios? {
        return db.ratios[stockSymbol]
    }
    
    func fetchGrowthRates() async -> GrowthRates? {
        return db.growthRates[stockSymbol]
    }
    
    func fetchMetrics() async -> Metrics? {
        return db.metrics[stockSymbol]
    }
    
    
}

protocol StockServiceProtocol {
    func fetchProfile() async -> CompanyProfile?
    func fetchPriceInRealTime() async -> CurrentPrice?
    func fetchPriceAtDate(date: String) async -> Double
    func fetchMarketCap() async -> Int
    func fetchRatios() async -> Ratios?
    func fetchGrowthRates() async -> GrowthRates?
    func fetchMetrics() async -> Metrics?
}

