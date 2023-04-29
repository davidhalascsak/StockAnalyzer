import Foundation

class ChartService: ChartServiceProtocol {
    let symbol: String
    
    init(symbol: String) {
        self.symbol = symbol
    }
    
    func get5Min() async -> [ChartData] {
        guard let url = URL(string:  "https://financialmodelingprep.com/api/v3/historical-chart/5min/\(symbol)?apikey=\(ApiKeys.financeApi)")
        else {return []}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let chartData = try? decoder.decode([ChartData].self, from: data)
            return chartData ?? []
        } catch {
            return []
        }
    }
    
    func getHourly() async -> [ChartData] {
        guard let url = URL(string:  "https://financialmodelingprep.com/api/v3/historical-chart/1hour/\(symbol)?apikey=\(ApiKeys.financeApi)")
        else {return []}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let chartData = try? decoder.decode([ChartData].self, from: data)
            
            return chartData ?? []
        } catch {
            return []
        }
    }
    
    func getDaily() async -> [ChartData] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let startDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
        
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/historical-price-full/\(symbol)?from=\(formatter.string(from: startDate))&to=\(formatter.string(from: Date()))&apikey=\(ApiKeys.financeApi)")
        else {return []}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let chartData = try? decoder.decode(HistoricPrice.self, from: data)
            
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
    
    func get5Min() async -> [ChartData] {
        return db.FiveMinData[symbol] ?? []
    }
    
    func getHourly() async -> [ChartData] {
        return db.OneHourData[symbol] ?? []
    }
    
    func getDaily() async -> [ChartData] {
        return db.DailyData[symbol] ?? []
    }
}

protocol ChartServiceProtocol {
    func get5Min() async -> [ChartData]
    func getHourly() async -> [ChartData]
    func getDaily() async -> [ChartData]
}
