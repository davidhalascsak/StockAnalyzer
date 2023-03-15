import Foundation
import Combine

class ChartViewModel: ObservableObject {
    var fiveMinutesData: [ChartData] = []
    var hourlyData: [ChartData] = []
    var dailyData: [ChartData] = []
    
    @Published var chartData: [ChartData] = []
    @Published var xAxisData: ChartAxisData?
    @Published var yAxisData: ChartAxisData?
    
    @Published var minValues: [String: Double] = [:]
    @Published var maxValues: [String: Double] = [:]
    
    @Published var selectedType: ChartOption = .oneDay
    
    @Published var isLoading: Bool = false
    
    
    var dataSubscription: AnyCancellable?
    var dateFormat: String {
        switch self.selectedType {
            case .oneDay:
                return "H"
            case .oneWeek:
                return "d"
            case .oneMonth:
                return "d"
            case .oneYear:
                return "MMMM"
        }
    }
    
    let symbol: String
    let exchange: String
    var openDate: String {
        var calendar = Calendar(identifier: .gregorian)
        let timezone = TimeZone(abbreviation: Exchange.exchanges[self.exchange]!["timezone"] ?? "GMT")
        calendar.timeZone = timezone ?? .gmt

        let current = calendar.dateComponents(in: timezone ?? .gmt, from: Date())
        
        let month: String = current.month! < 10 ? "0\(current.month!)" : String(current.month!)
        let day: String = current.day! < 10 ? "0\(current.day!)" : String(current.day!)
        
        let date: String = "\(current.year!)-\(month)-\(day) " + Exchange.exchanges[self.exchange]!["open"]!
    
        return date
    }
    var closeDate: String {
        var calendar = Calendar(identifier: .gregorian)
        let timezone = TimeZone(abbreviation: Exchange.exchanges[self.exchange]!["timezone"] ?? "GMT")
        calendar.timeZone = timezone ?? .gmt

        let current = calendar.dateComponents(in: timezone ?? .gmt, from: Date())
        
        let month: String = current.month! < 10 ? "0\(current.month!)" : String(current.month!)
        let day: String = current.day! < 10 ? "0\(current.day!)" : String(current.day!)
        
        let date: String = "\(current.year!)-\(month)-\(day) " + Exchange.exchanges[self.exchange]!["close"]!
    
        return date
    }
    var timezone: String {
        return Exchange.exchanges[self.exchange]!["timezone"] ?? "GMT"
    }
    let chartOptions = ["1D", "1W", "1M", "1Y"]
    let dateFormatter = DateFormatter()
    
    init(symbol: String, exchange: String) {
        self.symbol = symbol
        self.exchange = exchange
        
        fetchData()
    }
    
    func fetchData() {
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
        
        if self.fiveMinutesData.isEmpty {
            guard let url = URL(string:  "https://financialmodelingprep.com/api/v3/historical-chart/5min/\(symbol)?apikey=\(ApiKeys.financeApi)")
            else {return}
            
            dataSubscription = NetworkingManager.download(url: url)
                .decode(type: [ChartData].self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedData) in
                    self?.fiveMinutesData = returnedData
                    
                    if self?.selectedType == .oneDay {
                        self?.chartData = self?.createDailyData(data: self?.fiveMinutesData ?? []) ?? []
                    } else {
                        self?.chartData = self?.createWeeklyData(data: self?.fiveMinutesData ?? []) ?? []
                    }
                    
                    self?.xAxisData = self?.xAxisChartData()
                    self?.yAxisData = self?.yAxisChartData()
                    
                    self?.isLoading = false
                    self?.dataSubscription?.cancel()
                })
        } else {
            if self.selectedType == .oneDay {
                self.chartData = self.createDailyData(data: self.fiveMinutesData)
            } else {
                self.chartData = self.createWeeklyData(data: self.fiveMinutesData)
            }
            self.xAxisData = self.xAxisChartData()
            self.yAxisData = self.yAxisChartData()
            self.isLoading = false
        }
    }
    
    func getHourly(symbol: String) {
        if self.hourlyData.isEmpty {
            guard let url = URL(string:  "https://financialmodelingprep.com/api/v3/historical-chart/1hour/\(symbol)?apikey=\(ApiKeys.financeApi)")
            else {return}
            
            dataSubscription = NetworkingManager.download(url: url)
                .decode(type: [ChartData].self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedData) in
                    self?.hourlyData = returnedData
                    
                    self?.chartData = self?.createMonthlyData(data: self?.hourlyData ?? []) ?? []
                    self?.xAxisData = self?.xAxisChartData()
                    self?.yAxisData = self?.yAxisChartData()
                    
                    self?.isLoading = false
                    self?.dataSubscription?.cancel()
                })
        } else {
            self.chartData = self.createMonthlyData(data: self.hourlyData)
            self.xAxisData = self.xAxisChartData()
            self.yAxisData = self.yAxisChartData()
            self.isLoading = false
        }
    }
    
    func getDaily(symbol: String) {
        if self.dailyData.isEmpty {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            let startDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
            
            guard let url = URL(string: "https://financialmodelingprep.com/api/v3/historical-price-full/\(symbol)?from=\(formatter.string(from: startDate))&to=\(formatter.string(from: Date()))&apikey=\(ApiKeys.financeApi)")
            else {return}
            
            dataSubscription = NetworkingManager.download(url: url)
                .decode(type: HistoricPrice.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedData) in
                    self?.dailyData = returnedData.historical.reversed()
                    
                    self?.chartData = self?.dailyData ?? []
                    self?.xAxisData = self?.xAxisChartData()
                    
                    self?.minValues["1Y"] = self?.dailyData.map {$0.open}.min()
                    self?.maxValues["1Y"] = self?.dailyData.map {$0.open}.max()
                    
                    self?.yAxisData = self?.yAxisChartData()
                    
                    self?.isLoading = false
                    self?.dataSubscription?.cancel()
                })
        } else {
            self.chartData = self.dailyData
            self.xAxisData = self.xAxisChartData()
            self.yAxisData = self.yAxisChartData()
            self.isLoading = false
        }
    }
    
    func createDailyData(data: [ChartData]) -> [ChartData] {
        
        var daily = [ChartData]()
        for i in 0..<data.count {
            if data[i].date[0..<10] == data[0].date[0..<10] {
                daily.append(data[i])
            } else {
                break
            }
        }
        
        self.minValues["1D"] = daily.map {$0.open}.min()
        self.maxValues["1D"] = daily.map {$0.open}.max()
        
        return daily.reversed()
    }
    
    func createWeeklyData(data: [ChartData]) -> [ChartData] {
        var dayCount = 0
        var weekly = [ChartData]()
        
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
        
        return weekly.reversed()
    }
    
    func createMonthlyData(data: [ChartData]) -> [ChartData] {
        var monthly = [ChartData]()
        
        var date = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let dateString = formatter.string(from: date)
        
        var index = 0
        while(data[index].date[0..<10] > dateString) {
            monthly.append(data[index])
            index += 1
        }
        
        self.minValues["1M"] = monthly.map {$0.open}.min()
        self.maxValues["1M"] = monthly.map {$0.open}.max()
        
        return monthly.reversed()
    }
    
    func xAxisChartData() -> ChartAxisData {
        let timezone = TimeZone(abbreviation: "CET")
        dateFormatter.locale = Locale(identifier: "en_us")
        dateFormatter.timeZone = timezone
        dateFormatter.dateFormat = self.dateFormat
        
        var xAxisDateComponents = Set<DateComponents>()
        
        if let startDateString = chartData.first?.date {
            let startDate = self.createDate(dateString: startDateString)
            if self.selectedType == .oneDay {
                let endDate = self.createDate(dateString: closeDate)
                xAxisDateComponents = getDateComponents(startDate: startDate, endDate: endDate, timezone: TimeZone(abbreviation: "CET")!)
            } else if let endDateString = chartData.last?.date {
                let endDate = self.createDate(dateString: endDateString)
                xAxisDateComponents = getDateComponents(startDate: startDate, endDate: endDate, timezone: TimeZone(abbreviation: "CET")!)
            }
        }
        var map = [String: String]()
        var axisEnd: Int = chartData.count - 1
        
        for (index, value) in self.chartData.enumerated() {
            let dc = self.createDate(dateString: value.date).dateComponents(timezone: .gmt, selectedType: self.selectedType)
            
            if xAxisDateComponents.contains(dc) {
                map[String(index)] = dateFormatter.string(from: self.createDate(dateString: value.date))
                
                xAxisDateComponents.remove(dc)
            }
        }
        
        if selectedType == .oneDay {
            var date: Date = self.createDate(dateString: self.chartData.last!.date)
            if date >= self.createDate(dateString: openDate) && date < self.createDate(dateString: closeDate) {
                while date < self.createDate(dateString: closeDate) {
                    axisEnd += 1
                    date = Calendar.current.date(byAdding: .minute, value: 5, to: date)!
                    let dc = date.dateComponents(timezone: .gmt, selectedType: .oneDay)
                            if xAxisDateComponents.contains(dc) {
                                map[String(axisEnd)] = dateFormatter.string(from: date)
                                xAxisDateComponents.remove(dc)
                            }
                        }
            }
        }
        
        return ChartAxisData(axisStart: 0, axisEnd: Double(max(0, axisEnd)), strideBy: 1, map: map)
    }
    
    func yAxisChartData() -> ChartAxisData {
        var lowest = self.minValues[self.selectedType.rawValue] ?? 0
        var highest = self.maxValues[self.selectedType.rawValue] ?? 0
        
        let difference = highest - lowest
        let numberOfLines: Double = 4
        var shouldCeilIncrement: Bool
        var strideBy: Double
        
        if difference < numberOfLines {
            shouldCeilIncrement = false
            strideBy = 0.01
        } else {
            shouldCeilIncrement = true
            lowest = floor(lowest)
            highest = ceil(highest)
            strideBy = 1.0
        }
        
        let increment = ((highest - lowest) / (numberOfLines))
        var map = [String: String]()
        map[highest.roundedString] = formatYAxisLabel(value: highest, shouldCeilIncrement: shouldCeilIncrement)
        
        var current = lowest
        (0..<Int(numberOfLines) - 1).forEach { i in
            current += increment
            map[(shouldCeilIncrement ? ceil(current) : current).roundedString] = formatYAxisLabel(value: current, shouldCeilIncrement: shouldCeilIncrement)
        }
        
        return ChartAxisData(axisStart: lowest - 0.01, axisEnd: highest + 0.01, strideBy: strideBy, map: map)
    }
    
    func formatYAxisLabel(value: Double, shouldCeilIncrement: Bool) -> String {
        if shouldCeilIncrement {
            return String(Int(ceil(value)))
        } else {
            return value.roundedString
        }
    }
    
    func getDateComponents(startDate: Date, endDate: Date, timezone: TimeZone) -> Set<DateComponents> {
        var component: Calendar.Component
        var value: Int
        
        switch self.selectedType {
            case .oneDay:
                component = .hour
                value = 1
            case .oneWeek:
                component = .day
                value = 1
            case .oneMonth:
                component = .weekOfYear
                value = 1
            case .oneYear:
                component = .month
                value = 4
        }
        
        
        var set = Set<DateComponents>()
        var date = startDate
        
        if self.selectedType != .oneDay {
            set.insert(startDate.dateComponents(timezone: .gmt, selectedType: self.selectedType))
        }
        
        while date <= endDate {
            date = Calendar.current.date(byAdding: component, value: value, to: date)!
            set.insert(date.dateComponents(timezone: .gmt, selectedType: self.selectedType))
        }
        
        return set
    }
    
    func createDate(dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: self.timezone)
        
        
        
        if self.selectedType == .oneYear {
            formatter.dateFormat = "yyyy-MM-dd"
        } else {
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }
        
        return formatter.date(from: dateString)!
    }
}

struct ChartData: Codable, Hashable {
    let date: String
    let open: Double
    let close: Double
}

struct HistoricPrice: Codable, Hashable {
    let symbol: String
    let historical: [ChartData]
}
    
struct ChartAxisData {
    let axisStart: Double
    let axisEnd: Double
    let strideBy: Double
    let map: [String: String]
}

enum ChartOption: String {
    case oneDay = "1D", oneWeek = "1W", oneMonth = "1M", oneYear = "1Y"
}
