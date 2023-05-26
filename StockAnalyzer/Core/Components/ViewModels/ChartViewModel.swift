import Foundation

@MainActor
class ChartViewModel: ObservableObject {
    @Published var chartData: [HistoricalPrice] = []
    @Published var xAxisData: ChartAxisData?
    @Published var yAxisData: ChartAxisData?
    @Published var minValues: [String: Double] = [:]
    @Published var maxValues: [String: Double] = [:]
    @Published var selectedType: ChartOptions = .oneDay
    @Published var isLoading: Bool = true
    
    var fiveMinutesData: [HistoricalPrice] = []
    var hourlyData: [HistoricalPrice] = []
    var dailyData: [HistoricalPrice] = []
    let chartService: ChartServiceProtocol
    
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
    let stockSymbol: String
    let exchange: String
    var openDate: String {
        var calendar = Calendar(identifier: .gregorian)
        let timezone = TimeZone(abbreviation: Exchange.exchanges[exchange]!["timezone"] ?? "GMT")
        calendar.timeZone = timezone ?? .gmt

        let current = calendar.dateComponents(in: timezone ?? .gmt, from: Date())
        
        let month: String = current.month ?? 0 < 10 ? "0\(current.month ?? 0)" : String(current.month ?? 0)
        let day: String = current.day ?? 0 < 10 ? "0\(current.day ?? 0)" : String(current.day ?? 0)
        
        let date: String = "\(current.year ?? 0)-\(month)-\(day) " + (Exchange.exchanges[exchange]?["open"] ?? "")
        
        return date
    }
    var closeDate: String {
        var calendar = Calendar(identifier: .gregorian)
        let timezone = TimeZone(abbreviation: Exchange.exchanges[exchange]?["timezone"] ?? "GMT")
        
        calendar.timeZone = timezone ?? .gmt

        let current = calendar.dateComponents(in: timezone ?? .gmt, from: Date())
        let month: String = current.month ?? 0 < 10 ? "0\(current.month ?? 0)" : String(current.month ?? 0)
        let day: String = current.day ?? 0 < 10 ? "0\(current.day ?? 0)" : String(current.day ?? 0)
        
        let date: String = "\(current.year ?? 0)-\(month)-\(day) " + (Exchange.exchanges[exchange]?["close"] ?? "")
    
        return date
    }
    var timezone: String {
        return Exchange.exchanges[exchange]!["timezone"] ?? "GMT"
    }
    
    init(stockSymbol: String, exchange: String, chartService: ChartServiceProtocol) {
        self.stockSymbol = stockSymbol
        self.exchange = exchange
        self.chartService = chartService
    }
    
    func fetchData() async {
        switch self.selectedType {
        case .oneDay, .oneWeek:
            await get5Min()
        case .oneMonth:
            await getHourly()
        default:
            await getDaily()
        }
    }
    
    func get5Min() async {
        if fiveMinutesData.isEmpty {
            fiveMinutesData = await chartService.get5Min()
            if !fiveMinutesData.isEmpty {
                if selectedType == .oneDay {
                    chartData = createDailyData(data: fiveMinutesData)
                } else {
                    chartData = createWeeklyData(data: fiveMinutesData)
                }
                xAxisData = xAxisChartData()
                yAxisData = yAxisChartData()

                isLoading = false
            }
        } else {
            if selectedType == .oneDay {
                chartData = createDailyData(data: fiveMinutesData)
            } else {
                chartData = createWeeklyData(data: fiveMinutesData)
            }
            
            xAxisData = xAxisChartData()
            yAxisData = yAxisChartData()
            
            isLoading = false
        }
    }
    
    func getHourly() async {
        if hourlyData.isEmpty {
            hourlyData = await chartService.getHourly()

            if !hourlyData.isEmpty {
                chartData = createMonthlyData(data: hourlyData)
                xAxisData = xAxisChartData()
                yAxisData = yAxisChartData()
                
                isLoading = false
            }
        } else {
            chartData = createMonthlyData(data: hourlyData)
            xAxisData = xAxisChartData()
            yAxisData = yAxisChartData()
            
            isLoading = false
        }
    }
    
    func getDaily() async {
        if dailyData.isEmpty {
            dailyData = await chartService.getDaily().reversed()

            if !dailyData.isEmpty {
                chartData = dailyData
                
                minValues["1Y"] = dailyData.map {$0.open}.min()
                maxValues["1Y"] = dailyData.map {$0.open}.max()
                
                xAxisData = xAxisChartData()
                yAxisData = yAxisChartData()
                
                isLoading = false
            }
        } else {
            chartData = dailyData
            xAxisData = xAxisChartData()
            yAxisData = yAxisChartData()
            
            isLoading = false
        }
    }
    
    func createDailyData(data: [HistoricalPrice]) -> [HistoricalPrice] {
        var daily = [HistoricalPrice]()
        for i in 0..<data.count {
            if data[i].date[0..<10] == data[0].date[0..<10] {
                daily.append(data[i])
            } else {
                break
            }
        }
        
        minValues["1D"] = daily.map {$0.open}.min()
        maxValues["1D"] = daily.map {$0.open}.max()
        
        return daily.reversed()
    }
    
    func createWeeklyData(data: [HistoricalPrice]) -> [HistoricalPrice] {
        var dayCount = 0
        var weekly = [HistoricalPrice]()
        
        weekly.append(data[0])
        
        for index in 1..<data.count {
            if dayCount == 5 {
                break
            } else if data[index].date[0..<11] == data[index - 1].date[0..<11] {
                weekly.append(data[index])
            } else {
                dayCount += 1
            }
        }

        minValues["1W"] = weekly.map {$0.open}.min()
        maxValues["1W"] = weekly.map {$0.open}.max()
        
        return weekly.reversed()
    }
    
    func createMonthlyData(data: [HistoricalPrice]) -> [HistoricalPrice] {
        var monthly = [HistoricalPrice]()
        
        var date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        date = Calendar.current.date(byAdding: .day, value: -1, to: date) ?? Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let dateString = formatter.string(from: date)
        
        for index in 0..<data.count {
            if data[index].date[0..<10] > dateString {
                monthly.append(data[index])
            } else {
                break
            }
        }

        minValues["1M"] = monthly.map {$0.open}.min()
        maxValues["1M"] = monthly.map {$0.open}.max()
        
        return monthly.reversed()
    }
    
    func xAxisChartData() -> ChartAxisData {
        let formatter = DateFormatter()
        let timezone = TimeZone.current
        formatter.locale = Locale(identifier: "en_us")
        formatter.timeZone = timezone
        formatter.dateFormat = dateFormat
        
        var xAxisDateComponents = Set<DateComponents>()
        if let startDateString = chartData.first?.date {
            let startDate = stringToDate(dateString: startDateString) ?? Date()
            if selectedType == .oneDay {
                let endDate = stringToDate(dateString: closeDate) ?? Date()
                xAxisDateComponents = getDateComponents(startDate: startDate, endDate: endDate, timezone: TimeZone.current)
            } else if let endDateString = chartData.last?.date {
                let endDate = stringToDate(dateString: endDateString) ?? Date()
                xAxisDateComponents = getDateComponents(startDate: startDate, endDate: endDate, timezone: TimeZone.current)
            }
        }
        var map = [String: String]()
        var axisEnd: Int = chartData.count - 1
        
        for (index, value) in chartData.enumerated() {
            let date = stringToDate(dateString: value.date) ?? Date()
            let dc = date.dateComponents(timezone: TimeZone.current, selectedType: selectedType)
            
            if xAxisDateComponents.contains(dc) {
                map[String(index)] = formatter.string(from: stringToDate(dateString: value.date) ?? Date())
                
                xAxisDateComponents.remove(dc)
            }
        }
        
        if selectedType == .oneDay {
            var date: Date = stringToDate(dateString: chartData.last?.date ?? "0000-00-00 00:00:00") ?? Date()
            if date >= stringToDate(dateString: openDate) ?? Date() && date < stringToDate(dateString: closeDate) ?? Date() {
                while date < stringToDate(dateString: closeDate) ?? Date() {
                    axisEnd += 1
                    date = Calendar.current.date(byAdding: .minute, value: 5, to: date)!
                    let dc = date.dateComponents(timezone: TimeZone.current, selectedType: .oneDay)
                            if xAxisDateComponents.contains(dc) {
                                map[String(axisEnd)] = formatter.string(from: date)
                                xAxisDateComponents.remove(dc)
                            }
                        }
            }
        }
        
        return ChartAxisData(axisStart: 0, axisEnd: Double(max(0, axisEnd)), strideBy: 1, map: map)
    }
    
    func yAxisChartData() -> ChartAxisData {
        var lowest = minValues[selectedType.rawValue] ?? 0
        var highest = maxValues[selectedType.rawValue] ?? 0
        
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
            set.insert(startDate.dateComponents(timezone: TimeZone.current, selectedType: selectedType))
            date = Calendar.current.date(byAdding: component, value: value, to: date) ?? Date()
        } else {
            date = Calendar.current.date(byAdding: component, value: value, to: date) ?? Date()
        }
        
        while date <= endDate {
            set.insert(date.dateComponents(timezone: TimeZone.current, selectedType: selectedType))
            date = Calendar.current.date(byAdding: component, value: value, to: date) ?? Date()
        }
        return set
    }
    
    func stringToDate(dateString: String) -> Date?  {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: timezone)
        
        
        
        if selectedType == .oneYear {
            formatter.dateFormat = "yyyy-MM-dd"
        } else {
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }
        return formatter.date(from: dateString) ?? nil
    }
}
