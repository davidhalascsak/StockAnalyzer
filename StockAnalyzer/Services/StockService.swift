import Foundation


class StockService: StockServiceProtocol {
    let symbol: String
    
    init(symbol: String) {
        self.symbol = symbol
    }
    
    func fetchProfile() async -> Company? {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/profile/\(self.symbol)?apikey=\(ApiKeys.financeApi)")
        else {return nil}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let company = try? decoder.decode([Company].self, from: data)
            if let company = company {
                return company[0]
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    func fetchPriceInRealTime() async -> Price? {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/quote/\(self.symbol)?apikey=\(ApiKeys.financeApi)")
        else {return nil}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let price = try? decoder.decode([Price].self, from: data)
           
            if let price = price {
                return price[0]
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    func fetchPriceAtDate(date: String) async -> Double {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/historical-price-full/\(self.symbol)?from=\(date)&to=\(date)&apikey=\(ApiKeys.financeApi)") else {return 0.0}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let price = try? decoder.decode(PriceAtDate.self, from: data)
           
            if let price = price {
                if price.historical.count == 1 {
                    return price.historical[0].open
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return 0.0
    }
    
    func fetchMarketCap() async -> MarketCap? {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/market-capitalization/\(self.symbol)?apikey=\(ApiKeys.financeApi)") else {return nil}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let marketCap = try? decoder.decode([MarketCap].self, from: data)
           
            if let marketCap = marketCap {
                return marketCap[0]
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    func fetchRatios() async -> Ratios? {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/ratios-ttm/\(self.symbol)?apikey=\(ApiKeys.financeApi)") else {return nil}
                
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let ratios = try? decoder.decode([Ratios].self, from: data)
           
            if let ratios = ratios {
                return ratios[0]
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    func fetchGrowthRates() async -> GrowthRates? {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/financial-growth/\(self.symbol)?limit=1&apikey=\(ApiKeys.financeApi)") else {return nil}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let growthRates = try? decoder.decode([GrowthRates].self, from: data)
           
            if let growthRates = growthRates {
                return growthRates[0]
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    func fetchMetrics() async -> Metrics? {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/key-metrics-ttm/\(self.symbol)?limit=1&apikey=\(ApiKeys.financeApi)") else {return nil}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let metrics = try? decoder.decode([Metrics].self, from: data)
           
            if let metrics = metrics {
                return metrics[0]
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return nil
    }
}

class MockStockService: StockServiceProtocol {
    func fetchProfile() async -> Company? {
        return  Company(symbol: "AAPL", price: 145.85, changes:  2.4200134, exchangeShortName: "NASDAQ", companyName: "Apple Inc.", currency: "USD", industry: "Consumer Electronics", description: "Apple Inc. designs, manufactures, and markets smartphones, personal computers, tablets, wearables, and accessories worldwide. It also sells various related services. The company offers iPhone, a line of smartphones; Mac, a line of personal computers; iPad, a line of multi-purpose tablets; and wearables, home, and accessories comprising AirPods, Apple TV, Apple Watch, Beats products, HomePod, iPod touch, and other Apple-branded and third-party accessories. It also provides AppleCare support services; cloud services store services; and operates various platforms, including the App Store, that allow customers to discover and download applications and digital content, such as books, music, video, games, and podcasts. In addition, the company offers various services, such as Apple Arcade, a game subscription service; Apple Music, which offers users a curated listening experience with on-demand radio stations; Apple News+, a subscription news and magazine service; Apple TV+, which offers exclusive original content; Apple Card, a co-branded credit card; and Apple Pay, a cashless payment service, as well as licenses its intellectual property. The company serves consumers, and small and mid-sized businesses; and the education, enterprise, and government markets. It sells and delivers third-party applications for its products through the App Store. The company also sells its products through its retail and online stores, and direct sales force; and third-party cellular network carriers, wholesalers, retailers, and resellers. Apple Inc. was founded in 1977 and is headquartered in Cupertino, California.", ceo: "Mr. Timothy Cook", sector: "Technology", country: "US", fullTimeEmployees: "147000", city: "Cupertino", state: "CALIFORNIA", image: "https://financialmodelingprep.com/image-stock/AAPL.png")
    }
    
    func fetchPriceInRealTime() async -> Price? {
        return Price(price: 110, changesPercentage: 10.0, change: 10.0)
    }
    
    func fetchPriceAtDate(date: String) async -> Double {
        return Double.random(in: 0..<10)
    }
    
    func fetchMarketCap() async -> MarketCap? {
        return MarketCap(marketCap: 10000000)
    }
    
    func fetchRatios() async -> Ratios? {
        return nil
    }
    
    func fetchGrowthRates() async -> GrowthRates? {
        return nil
    }
    
    func fetchMetrics() async -> Metrics? {
        return nil
    }
    
    
}

protocol StockServiceProtocol {
    func fetchProfile() async -> Company?
    func fetchPriceInRealTime() async -> Price?
    func fetchPriceAtDate(date: String) async -> Double
    func fetchMarketCap() async -> MarketCap?
    func fetchRatios() async -> Ratios?
    func fetchGrowthRates() async -> GrowthRates?
    func fetchMetrics() async -> Metrics?
}

