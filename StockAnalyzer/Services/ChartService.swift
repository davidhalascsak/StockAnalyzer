import Foundation

class ChartService: ChartServiceProtocol {
    let symbol: String
    
    init(symbol: String) {
        self.symbol = symbol
    }
    
    func get5Min() async -> [ChartData] {
        guard let url = URL(string:  "https://financialmodelingprep.com/api/v3/historical-chart/5min/\(self.symbol)?apikey=\(ApiKeys.financeApi)")
        else {return []}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let chartData = try? decoder.decode([ChartData].self, from: data)
            if let chartData = chartData {
                return chartData
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return []
    }
    
    func getHourly() async -> [ChartData] {
        guard let url = URL(string:  "https://financialmodelingprep.com/api/v3/historical-chart/1hour/\(self.symbol)?apikey=\(ApiKeys.financeApi)")
        else {return []}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let chartData = try? decoder.decode([ChartData].self, from: data)
            if let chartData = chartData {
                return chartData
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return []
    }
    
    func getDaily() async -> [ChartData] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let startDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
        
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/historical-price-full/\(self.symbol)?from=\(formatter.string(from: startDate))&to=\(formatter.string(from: Date()))&apikey=\(ApiKeys.financeApi)")
        else {return []}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let chartData = try? decoder.decode(HistoricPrice.self, from: data)
            if let chartData = chartData {
                return chartData.historical
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return []
    }
}

protocol ChartServiceProtocol {
    func get5Min() async -> [ChartData]
    func getHourly() async -> [ChartData]
    func getDaily() async -> [ChartData]
}
