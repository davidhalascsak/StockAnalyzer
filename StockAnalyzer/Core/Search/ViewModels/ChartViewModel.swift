import Foundation
import Combine

class ChartViewModel: ObservableObject {
    @Published var fiveMinutesData: [Price] = []
    @Published var hourlyData: [Price] = []
    @Published var dailyData: [Price] = []
    
    @Published var chartData: [Price] = []
    @Published var minValues: [String: Double] = [:]
    @Published var maxValues: [String: Double] = [:]
    @Published var selectedType: ChartOption = .oneMonth
    
    @Published var isLoading: Bool = false
    
    
    var dataSubscription: AnyCancellable?
    
    let symbol: String
    let chartOptions = ["1D", "1W", "1M", "1Y"]
    
    
    init(symbol: String) {
        self.symbol = symbol
        
        fetchData()
    }
    
    func fetchData() {
        print("fetching again")
        print(selectedType)
        self.isLoading = true
        switch self.selectedType {
        case .oneDay, .oneWeek:
            get5Min(symbol: self.symbol)
        case .oneMonth:
            getHourly(symbol: self.symbol)
        default:
            getDaily(symbol: self.symbol)
        }
    }
    
    func get5Min(symbol: String) {
        guard let url = URL(string:  "https://financialmodelingprep.com/api/v3/historical-chart/5min/\(symbol)?apikey=d5f365f0f57c273c26a6b52b86a53010")
        else {return}
        
        dataSubscription = NetworkingManager.download(url: url)
            .decode(type: [Price].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedData) in
                self?.fiveMinutesData = self?.createDailyData(data: returnedData) ?? []
                
                if self?.selectedType == .oneDay {
                    self?.chartData = self?.createDailyData(data: self?.fiveMinutesData ?? []) ?? []
                } else {
                    print("inside monthly")
                    self?.chartData = self?.createWeeklyData(data: self?.fiveMinutesData ?? []) ?? []
                }
                
                self?.isLoading = false
                self?.dataSubscription?.cancel()
            })
    }
    
    func getHourly(symbol: String) {
        guard let url = URL(string:  "https://financialmodelingprep.com/api/v3/historical-chart/1hour/\(symbol)?apikey=d5f365f0f57c273c26a6b52b86a53010")
        else {return}
        
        dataSubscription = NetworkingManager.download(url: url)
            .decode(type: [Price].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedData) in
                self?.hourlyData = returnedData
                
                self?.chartData = self?.createMonthlyData(data: self?.hourlyData ?? []) ?? []
                
                self?.isLoading = false
                self?.dataSubscription?.cancel()
            })
    }
    
    func getDaily(symbol: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let startDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
        
        guard let url = URL(string:          "https://financialmodelingprep.com/api/v3/historical-price-full/\(symbol)?from=\(formatter.string(from: startDate))&to=\(formatter.string(from: Date()))&apikey=d5f365f0f57c273c26a6b52b86a53010")
        else {return}
        
        dataSubscription = NetworkingManager.download(url: url)
            .decode(type: HistoricPrice.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedData) in
                self?.dailyData = returnedData.historical
                
                self?.chartData = self?.dailyData ?? []
                
                self?.minValues["1Y"] = self?.dailyData.map {$0.open}.min()
                self?.maxValues["1Y"] = self?.dailyData.map {$0.open}.max()
                
                self?.isLoading = false
                self?.dataSubscription?.cancel()
            })
    }
    
    func createDailyData(data: [Price]) -> [Price] {
        
        var daily = [Price]()
        for i in 0..<data.count {
            if data[i].date[0..<10] == data[0].date[0..<10] {
                daily.append(data[i])
            } else {
                break
            }
        }
        
        self.minValues["1D"] = daily.map {$0.open}.min()
        self.maxValues["1D"] = daily.map {$0.open}.max()
        
        return daily
    }
    
    func createWeeklyData(data: [Price]) -> [Price] {
        var dayCount = 0
        var weekly = [Price]()
        
        weekly.append(data[0])
        
        for i in 1..<data.count {
            if dayCount == 5 {
                break
            } else if data[i].date[0..<11] == data[i-1].date[0..<11] {
                weekly.append(data[i])
            } else {
                dayCount += 1
            }
        }
        
        self.minValues["1W"] = weekly.map {$0.open}.min()
        self.maxValues["1W"] = weekly.map {$0.open}.max()
        
        return weekly
    }
    
    func createMonthlyData(data: [Price]) -> [Price] {
        var monthly = [Price]()
        
        var date = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let dateString = formatter.string(from: date)
        
        var index = 0
        while(data[index].date[0..<10] != dateString) {
            monthly.append(data[index])
            index += 1
        }
        
        self.minValues["1M"] = monthly.map {$0.open}.min()
        self.maxValues["1M"] = monthly.map {$0.open}.max()
        
        return monthly
    }
    
    func createDate(dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter.date(from: dateString)!
    }
}

struct Price: Codable, Hashable {
    let date: String
    let open: Double
    let close: Double
}

struct HistoricPrice: Codable, Hashable {
    let symbol: String
    let historical: [Price]
}

enum ChartOption: String, CaseIterable {
    case oneDay = "1D", oneWeek = "1W", oneMonth = "1M", oneYear = "1Y"
}
