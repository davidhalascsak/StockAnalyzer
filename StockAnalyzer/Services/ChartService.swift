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
    
    func get5Min() async -> [ChartData] {
        return [
            ChartData(date: "2020-03-02 09:30:00", open: 280, close: 280),
            ChartData(date: "2020-03-02 09:35:00", open: 285, close: 285),
            ChartData(date: "2020-03-02 09:40:00", open: 290, close: 290),
            ChartData(date: "2020-03-02 09:35:00", open: 280, close: 280),
            ChartData(date: "2020-03-02 09:50:00", open: 280, close: 280),
            ChartData(date: "2020-03-02 09:55:00", open: 280, close: 280),
            ChartData(date: "2020-03-02 09:00:00", open: 300, close: 300),
            ChartData(date: "2020-03-02 09:05:00", open: 280, close: 280),
            ChartData(date: "2020-03-02 09:10:00", open: 280, close: 280),
            ChartData(date: "2020-03-02 09:15:00", open: 275, close: 275),
            ChartData(date: "2020-03-02 09:20:00", open: 280, close: 280),
            ChartData(date: "2020-03-02 09:25:00", open: 280, close: 280),
            ChartData(date: "2020-03-02 09:25:00", open: 280, close: 280),
            ChartData(date: "2020-03-02 09:30:00", open: 280, close: 280)
        ]
    }
    
    func getHourly() async -> [ChartData] {
        return [
            ChartData(date: "2020-03-02 10:00:00", open: 280, close: 280),
            ChartData(date: "2020-03-02 11:00:00", open: 285, close: 285),
            ChartData(date: "2020-03-02 12:00:00", open: 290, close: 290),
            ChartData(date: "2020-03-02 13:00:00", open: 280, close: 280),
            ChartData(date: "2020-03-02 14:00:00", open: 280, close: 280),
            ChartData(date: "2020-03-02 15:00:00", open: 280, close: 280),
            ChartData(date: "2020-03-02 16:00:00", open: 300, close: 300),
            ChartData(date: "2020-03-03 10:00:00", open: 280, close: 280),
            ChartData(date: "2020-03-03 11:00:00", open: 280, close: 280),
            ChartData(date: "2020-03-03 12:00:00", open: 275, close: 275),
            ChartData(date: "2020-03-03 13:00:00", open: 280, close: 280),
            ChartData(date: "2020-03-03 14:00:00", open: 280, close: 280),
            ChartData(date: "2020-03-03 15:00:00", open: 280, close: 280),
            ChartData(date: "2020-03-03 16:00:00", open: 280, close: 280)
        ]
    }
    
    func getDaily() async -> [ChartData] {
        return [
            ChartData(date: "2020-03-02", open: 280, close: 280),
            ChartData(date: "2020-03-03", open: 285, close: 285),
            ChartData(date: "2020-03-04", open: 290, close: 290),
            ChartData(date: "2020-03-05", open: 280, close: 280),
            ChartData(date: "2020-03-06", open: 280, close: 280),
            ChartData(date: "2020-03-09", open: 280, close: 280),
            ChartData(date: "2020-03-10", open: 300, close: 300),
            ChartData(date: "2020-03-11", open: 280, close: 280),
            ChartData(date: "2020-03-12", open: 280, close: 280),
            ChartData(date: "2020-03-13", open: 275, close: 275),
            ChartData(date: "2020-03-16", open: 280, close: 280),
            ChartData(date: "2020-03-17", open: 280, close: 280),
            ChartData(date: "2020-03-18", open: 280, close: 280),
            ChartData(date: "2020-03-19", open: 280, close: 280),
            ChartData(date: "2020-03-20", open: 285, close: 285)
        ]
    }
}

protocol ChartServiceProtocol {
    func get5Min() async -> [ChartData]
    func getHourly() async -> [ChartData]
    func getDaily() async -> [ChartData]
}
