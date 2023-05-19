import Foundation


class StockService: StockServiceProtocol {
    let symbol: String
    
    init(symbol: String) {
        self.symbol = symbol
    }
    
    func fetchProfile() async -> CompanyProfile? {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/profile/\(symbol)?apikey=\(ApiKeys.financeApi)")
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
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/quote/\(symbol)?apikey=\(ApiKeys.financeApi)")
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
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/historical-price-full/\(symbol)?from=\(date)&to=\(date)&apikey=\(ApiKeys.financeApi)") else {return 0.0}
        
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
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/market-capitalization/\(symbol)?apikey=\(ApiKeys.financeApi)") else {return 0}
        
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
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/ratios-ttm/\(symbol)?apikey=\(ApiKeys.financeApi)") else {return nil}
                
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
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/financial-growth/\(symbol)?limit=1&apikey=\(ApiKeys.financeApi)") else {return nil}
        
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
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/key-metrics-ttm/\(symbol)?limit=1&apikey=\(ApiKeys.financeApi)") else {return nil}
        
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
    func fetchProfile() async -> CompanyProfile? {
        return  CompanyProfile(symbol: "AAPL", price: 145.85, changes:  2.4200134,currency: "USD", exchangeShortName: "NASDAQ", companyName: "Apple Inc.", description: "Apple Inc. designs, manufactures, and markets smartphones, personal computers, tablets, wearables, and accessories worldwide. It also sells various related services. The company offers iPhone, a line of smartphones; Mac, a line of personal computers; iPad, a line of multi-purpose tablets; and wearables, home, and accessories comprising AirPods, Apple TV, Apple Watch, Beats products, HomePod, iPod touch, and other Apple-branded and third-party accessories. It also provides AppleCare support services; cloud services store services; and operates various platforms, including the App Store, that allow customers to discover and download applications and digital content, such as books, music, video, games, and podcasts. In addition, the company offers various services, such as Apple Arcade, a game subscription service; Apple Music, which offers users a curated listening experience with on-demand radio stations; Apple News+, a subscription news and magazine service; Apple TV+, which offers exclusive original content; Apple Card, a co-branded credit card; and Apple Pay, a cashless payment service, as well as licenses its intellectual property. The company serves consumers, and small and mid-sized businesses; and the education, enterprise, and government markets. It sells and delivers third-party applications for its products through the App Store. The company also sells its products through its retail and online stores, and direct sales force; and third-party cellular network carriers, wholesalers, retailers, and resellers. Apple Inc. was founded in 1977 and is headquartered in Cupertino, California.",fullTimeEmployees: "147000" ,  industry: "Consumer Electronics", sector: "Technology", ceo: "Mr. Timothy Cook", country: "US",  state: "CALIFORNIA",city: "Cupertino", image: "https://financialmodelingprep.com/image-stock/AAPL.png")
    }
    
    func fetchPriceInRealTime() async -> CurrentPrice? {
        return CurrentPrice(price: 110, change: 10.0, changeInPercentage: 10.0)
    }
    
    func fetchPriceAtDate(date: String) async -> Double {
        return 110
    }
    
    func fetchMarketCap() async -> Int {
        return 10000000
    }
    
    func fetchRatios() async -> Ratios? {
        return Ratios(peRatioTTM: 20, pegRatioTTM: 1, priceToSalesRatioTTM: 5, priceToBookRatioTTM: 10, dividendPerShareTTM: 1, dividendYielPercentageTTM: 2)
    }
    
    func fetchGrowthRates() async -> GrowthRates? {
        return GrowthRates(netIncomeGrowth: 10, freeCashFlowGrowth: 15, weightedAverageSharesGrowth: 1)
    }
    
    func fetchMetrics() async -> Metrics? {
        return Metrics(netIncomePerShareTTM: 3.0, freeCashFlowPerShareTTM: 3.0)
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

