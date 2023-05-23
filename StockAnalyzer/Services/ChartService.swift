import Foundation

class ChartService: ChartServiceProtocol {
    let stockSymbol: String
    
    init(stockSymbol: String) {
        self.stockSymbol = stockSymbol
    }
    
    func get5Min() async -> [HistoricalPrice] {
        guard let url = URL(string:  "https://financialmodelingprep.com/api/v3/historical-chart/5min/\(stockSymbol)?apikey=\(ApiKeys.financeApi)")
        else {return []}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let chartData = try? decoder.decode([HistoricalPrice].self, from: data)
            return chartData ?? []
        } catch {
            return []
        }
    }
    
    func getHourly() async -> [HistoricalPrice] {
        guard let url = URL(string:  "https://financialmodelingprep.com/api/v3/historical-chart/1hour/\(stockSymbol)?apikey=\(ApiKeys.financeApi)")
        else {return []}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let chartData = try? decoder.decode([HistoricalPrice].self, from: data)
            
            return chartData ?? []
        } catch {
            return []
        }
    }
    
    func getDaily() async -> [HistoricalPrice] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let startDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
        
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/historical-price-full/\(stockSymbol)?from=\(formatter.string(from: startDate))&to=\(formatter.string(from: Date()))&apikey=\(ApiKeys.financeApi)")
        else {return []}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let chartData = try? decoder.decode(PriceInterval.self, from: data)
            
            return chartData?.historical ?? []
        } catch {
            return []
        }
    }
}

class MockChartService: ChartServiceProtocol {
    var db: MockDatabase = MockDatabase()
    let symbol: String
    
    init(symbol: String) {
        self.symbol = symbol
    }
    
    func get5Min() async -> [HistoricalPrice] {
        return db.FiveMinData[symbol] ?? []
    }
    
    func getHourly() async -> [HistoricalPrice] {
        return db.OneHourData[symbol] ?? []
    }
    
    func getDaily() async -> [HistoricalPrice] {
        return db.DailyData[symbol] ?? []
    }
}

protocol ChartServiceProtocol {
    func get5Min() async -> [HistoricalPrice]
    func getHourly() async -> [HistoricalPrice]
    func getDaily() async -> [HistoricalPrice]
}
