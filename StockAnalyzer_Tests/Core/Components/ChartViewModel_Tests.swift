import XCTest

@testable import StockAnalyzer

@MainActor
final class ChartViewModel_Tests: XCTestCase {
    
    func test_ChartViewModel_FetchData_OneDay() async throws {
        //Given
        let symbol: String = "AAPL"
        let exchange: String = "NASDAQ"
        let vm = ChartViewModel(symbol: symbol, exchange: exchange, chartService: MockChartService(symbol: symbol))
        
        //When
        vm.selectedType = .oneDay
        await vm.fetchData()
        
        //Then
        XCTAssertFalse(vm.chartData.isEmpty)
        XCTAssertFalse(vm.isLoading)
    }
    
    func test_ChartViewModel_FetchData_OneWeek() async throws {
        //Given
        let symbol: String = "AAPL"
        let exchange: String = "NASDAQ"
        let vm = ChartViewModel(symbol: symbol, exchange: exchange, chartService: MockChartService(symbol: symbol))
        
        //When
        vm.selectedType = .oneWeek
        await vm.fetchData()
        
        //Then
        XCTAssertFalse(vm.chartData.isEmpty)
        XCTAssertFalse(vm.isLoading)
    }
    
    func test_ChartViewModel_FetchData_OneMonth() async throws {
        //Given
        let symbol: String = "AAPL"
        let exchange: String = "NASDAQ"
        let vm = ChartViewModel(symbol: symbol, exchange: exchange, chartService: MockChartService(symbol: symbol))
        
        //When
        vm.selectedType = .oneMonth
        await vm.fetchData()
        
        //Then
        XCTAssertFalse(vm.chartData.isEmpty)
        XCTAssertFalse(vm.isLoading)
    }
    
    func test_ChartViewModel_FetchData_OneYear() async throws {
        //Given
        let symbol: String = "AAPL"
        let exchange: String = "NASDAQ"
        let vm = ChartViewModel(symbol: symbol, exchange: exchange, chartService: MockChartService(symbol: symbol))
        
        //When
        vm.selectedType = .oneYear
        await vm.fetchData()
        
        //Then
        XCTAssertFalse(vm.chartData.isEmpty)
        XCTAssertFalse(vm.isLoading)
    }
    
    func test_ChartViewModel_get5Min_DataNotEmpty() async throws {
        //Given
        let symbol: String = "AAPL"
        let exchange: String = "NASDAQ"
        let vm = ChartViewModel(symbol: symbol, exchange: exchange, chartService: MockChartService(symbol: symbol))
        
        //When
        await vm.get5Min()
        
        //Then
        XCTAssertFalse(vm.isLoading)
        XCTAssertFalse(vm.fiveMinutesData.isEmpty)
        XCTAssertFalse(vm.chartData.isEmpty)
        XCTAssertNotNil(vm.xAxisData)
        XCTAssertNotNil(vm.yAxisData)
    }
    
    func test_ChartViewModel_get5Min_DataEmpty() async throws {
        //Given
        let symbol: String = "MSFT"
        let exchange: String = "NASDAQ"
        let vm = ChartViewModel(symbol: symbol, exchange: exchange, chartService: MockChartService(symbol: symbol))
        
        //When
        await vm.get5Min()
        
        //Then
        XCTAssertTrue(vm.isLoading)
        XCTAssertTrue(vm.fiveMinutesData.isEmpty)
        XCTAssertTrue(vm.chartData.isEmpty)
        XCTAssertNil(vm.xAxisData)
        XCTAssertNil(vm.yAxisData)
    }
    
    func test_ChartViewModel_getOneHour_DataNotEmpty() async throws {
        //Given
        let symbol: String = "AAPL"
        let exchange: String = "NASDAQ"
        let vm = ChartViewModel(symbol: symbol, exchange: exchange, chartService: MockChartService(symbol: symbol))
        
        //When
        await vm.getHourly()
        
        //Then
        XCTAssertFalse(vm.isLoading)
        XCTAssertFalse(vm.hourlyData.isEmpty)
        XCTAssertFalse(vm.chartData.isEmpty)
        XCTAssertNotNil(vm.xAxisData)
        XCTAssertNotNil(vm.yAxisData)
    }
    
    func test_ChartViewModel_getOneHour_DataEmpty() async throws {
        //Given
        let symbol: String = "MSFT"
        let exchange: String = "NASDAQ"
        let vm = ChartViewModel(symbol: symbol, exchange: exchange, chartService: MockChartService(symbol: symbol))
        
        //When
        await vm.getHourly()
        
        //Then
        XCTAssertTrue(vm.isLoading)
        XCTAssertTrue(vm.hourlyData.isEmpty)
        XCTAssertTrue(vm.chartData.isEmpty)
        XCTAssertNil(vm.xAxisData)
        XCTAssertNil(vm.yAxisData)
    }
    
    func test_ChartViewModel_getDaily_DataNotEmpty() async throws {
        //Given
        let symbol: String = "AAPL"
        let exchange: String = "NASDAQ"
        let vm = ChartViewModel(symbol: symbol, exchange: exchange, chartService: MockChartService(symbol: symbol))
        
        //When
        await vm.getDaily()
        
        //Then
        XCTAssertFalse(vm.isLoading)
        XCTAssertFalse(vm.dailyData.isEmpty)
        XCTAssertFalse(vm.chartData.isEmpty)
        XCTAssertNotNil(vm.xAxisData)
        XCTAssertNotNil(vm.yAxisData)
    }
    
    func test_ChartViewModel_getDaily_DataEmpty() async throws {
        //Given
        let symbol: String = "MSFT"
        let exchange: String = "NASDAQ"
        let vm = ChartViewModel(symbol: symbol, exchange: exchange, chartService: MockChartService(symbol: symbol))
        
        //When
        await vm.getDaily()
        
        //Then
        XCTAssertTrue(vm.isLoading)
        XCTAssertTrue(vm.dailyData.isEmpty)
        XCTAssertTrue(vm.chartData.isEmpty)
        XCTAssertNil(vm.xAxisData)
        XCTAssertNil(vm.yAxisData)
    }
    
    func test_ChartViewModel_DailyMinMax() async throws {
        //Given
        let symbol: String = "AAPL"
        let exchange: String = "NASDAQ"
        let vm = ChartViewModel(symbol: symbol, exchange: exchange, chartService: MockChartService(symbol: symbol))
        
        
        //When
        await vm.get5Min()
        
        //Then
        XCTAssertEqual(vm.minValues["1D"], vm.fiveMinutesData.map {$0.open}.min())
        XCTAssertEqual(vm.minValues["1D"], vm.fiveMinutesData.map {$0.open}.min())
    }
    
    func test_ChartViewModel_WeeklyMinMax() async throws {
        //Given
        let symbol: String = "AAPL"
        let exchange: String = "NASDAQ"
        let vm = ChartViewModel(symbol: symbol, exchange: exchange, chartService: MockChartService(symbol: symbol))
        
        
        //When
        vm.selectedType = .oneWeek
        await vm.get5Min()
        
        //Then
        XCTAssertEqual(vm.minValues["1W"], vm.fiveMinutesData.map {$0.open}.min())
        XCTAssertEqual(vm.minValues["1W"], vm.fiveMinutesData.map {$0.open}.min())
    }
    
    func test_ChartViewModel_MonthlyMinMax() async throws {
        //Given
        let symbol: String = "AAPL"
        let exchange: String = "NASDAQ"
        let vm = ChartViewModel(symbol: symbol, exchange: exchange, chartService: MockChartService(symbol: symbol))
        
        
        //When
        await vm.get5Min()
        
        //Then
        XCTAssertEqual(vm.minValues["1M"], vm.hourlyData.map {$0.open}.min())
        XCTAssertEqual(vm.minValues["1M"], vm.hourlyData.map {$0.open}.min())
    }
    
    func test_ChartViewModel_YearlyMinMax() async throws {
        //Given
        let symbol: String = "AAPL"
        let exchange: String = "NASDAQ"
        let vm = ChartViewModel(symbol: symbol, exchange: exchange, chartService: MockChartService(symbol: symbol))
        
        //When
        await vm.getDaily()
        
        //Then
        XCTAssertEqual(vm.minValues["1Y"], vm.dailyData.map {$0.open}.min())
        XCTAssertEqual(vm.minValues["1Y"], vm.dailyData.map {$0.open}.min())
    }
    
    func test_ChartViewModel_xAxisChartData_OneDay() async throws {
        let symbol: String = "AAPL"
        let exchange: String = "NASDAQ"
        let vm = ChartViewModel(symbol: symbol, exchange: exchange, chartService: MockChartService(symbol: symbol))
        
        //When
        vm.selectedType = .oneDay
        await vm.get5Min()
        let result = vm.xAxisChartData()
    
        //Then
        XCTAssertEqual(result.axisStart, 0.0)
        XCTAssertEqual(result.axisEnd, 13.0)
        XCTAssertEqual(result.strideBy, 1.0)
        XCTAssertEqual(result.map, ["6": "16"])
    }
    
    func test_ChartViewModel_xAxisChartData_OneWeak() async throws {
        let symbol: String = "AAPL"
        let exchange: String = "NASDAQ"
        let vm = ChartViewModel(symbol: symbol, exchange: exchange, chartService: MockChartService(symbol: symbol))
        
        //When
        vm.selectedType = .oneWeek
        await vm.get5Min()
        let result = vm.xAxisChartData()
    
        //Then
        XCTAssertEqual(result.axisStart, 0.0)
        XCTAssertEqual(result.axisEnd, 13.0)
        XCTAssertEqual(result.strideBy, 1.0)
        XCTAssertEqual(result.map, ["0": "2"])
    }
    
    func test_ChartViewModel_xAxisChartData_OneMonth() async throws {
        let symbol: String = "AAPL"
        let exchange: String = "NASDAQ"
        let vm = ChartViewModel(symbol: symbol, exchange: exchange, chartService: MockChartService(symbol: symbol))
        
        //When
        vm.selectedType = .oneMonth
        await vm.getHourly()
        let result = vm.xAxisChartData()
    
        //Then
        XCTAssertEqual(result.axisStart, 0.0)
        XCTAssertEqual(result.axisEnd, 13.0)
        XCTAssertEqual(result.strideBy, 1.0)
        XCTAssertEqual(result.map, ["0": "26"])
    }
    
    func test_ChartViewModel_xAxisChartData_OneYear() async throws {
        let symbol: String = "AAPL"
        let exchange: String = "NASDAQ"
        let vm = ChartViewModel(symbol: symbol, exchange: exchange, chartService: MockChartService(symbol: symbol))
        
        //When
        vm.selectedType = .oneYear
        await vm.getDaily()
        let result = vm.xAxisChartData()
    
        //Then
        XCTAssertEqual(result.axisStart, 0.0)
        XCTAssertEqual(result.axisEnd, 14.0)
        XCTAssertEqual(result.strideBy, 1.0)
        XCTAssertEqual(result.map, ["0": "March"])
    }
    
    func test_ChartViewModel_yAxisChartDate_One() async throws {
        let symbol: String = "AAPL"
        let exchange: String = "NASDAQ"
        let vm = ChartViewModel(symbol: symbol, exchange: exchange, chartService: MockChartService(symbol: symbol))
        
        //When
        vm.selectedType = .oneDay
        await vm.fetchData()
        let result = vm.yAxisChartData()
        
        //Then
        XCTAssertEqual(result.axisStart, 277.99)
        XCTAssertEqual(result.axisEnd, 281.01)
        XCTAssertEqual(result.strideBy, 0.01)
        XCTAssertEqual(result.map, ["281.00": "281.00", "279.50": "279.50", "280.25": "280.25", "278.75": "278.75"])
        
    }
    
    func test_ChartViewModel_yAxisChartDate_Two() async throws {
        let symbol: String = "AAPL"
        let exchange: String = "NASDAQ"
        let vm = ChartViewModel(symbol: symbol, exchange: exchange, chartService: MockChartService(symbol: symbol))
        
        //When
        vm.selectedType = .oneYear
        await vm.fetchData()
        let result = vm.yAxisChartData()
        
        //Then
        XCTAssertEqual(result.axisStart, 274.99)
        XCTAssertEqual(result.axisEnd, 300.01)
        XCTAssertEqual(result.strideBy, 1.0)
        XCTAssertEqual(result.map, ["294.00": "294", "288.00": "288", "282.00": "282", "300.00": "300"])
    }
    
    func test_ChartViewModel_FormatYAxisLabel_ShouldCeilIncrementIsTrue() throws {
        //Given
        let symbol: String = "AAPL"
        let exchange: String = "NASDAQ"
        let vm = ChartViewModel(symbol: symbol, exchange: exchange, chartService: MockChartService(symbol: symbol))
        
        //When
        let result = vm.formatYAxisLabel(value: 27.32, shouldCeilIncrement: true)
        
        //Then
        XCTAssertEqual("28", result)
    }
    
    func test_ChartViewModel_FormatYAxisLabel_ShouldCeilIncrementIsFalse() throws {
        //Given
        let symbol: String = "AAPL"
        let exchange: String = "NASDAQ"
        let vm = ChartViewModel(symbol: symbol, exchange: exchange, chartService: MockChartService(symbol: symbol))
        
        //When
        let result = vm.formatYAxisLabel(value: 27.32, shouldCeilIncrement: false)
        
        //Then
        XCTAssertEqual("27.32", result)
    }
    
    func test_ChartViewModel_getDateComponents_oneDay() throws {
        //Given
        let symbol: String = "AAPL"
        let exchange: String = "NASDAQ"
        var set = Set<DateComponents>()
        let vm = ChartViewModel(symbol: symbol, exchange: exchange, chartService: MockChartService(symbol: symbol))
        
        //When
        vm.selectedType = .oneDay
        let startDate = vm.stringToDate(dateString: "2023-04-25 9:30:00") ?? Date()
        let endDate = vm.stringToDate(dateString: "2023-04-25 13:00:00") ?? Date()
        let timezone = TimeZone(abbreviation: "EST") ?? .gmt
        let result = vm.getDateComponents(startDate: startDate, endDate: endDate, timezone: timezone)
        
        set.insert(DateComponents(timeZone: TimeZone.current, year: 2023, month: 4, day: 25, hour: 16))
        set.insert(DateComponents(timeZone: TimeZone.current, year: 2023, month: 4, day: 25, hour: 17))
        set.insert(DateComponents(timeZone: TimeZone.current, year: 2023, month: 4, day: 25, hour: 18))
        
        //Then
        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result, set)
    }
    
    func test_ChartViewModel_getDateComponents_oneWeek() throws {
        //Given
        let symbol: String = "AAPL"
        let exchange: String = "NASDAQ"
        var set = Set<DateComponents>()
        let vm = ChartViewModel(symbol: symbol, exchange: exchange, chartService: MockChartService(symbol: symbol))
        
        //When
        vm.selectedType = .oneWeek
        let startDate = vm.stringToDate(dateString: "2023-04-24 9:30:00") ?? Date()
        let endDate = vm.stringToDate(dateString: "2023-04-28 16:00:00") ?? Date()
        let timezone = TimeZone(abbreviation: "EST") ?? .gmt
        let result = vm.getDateComponents(startDate: startDate, endDate: endDate, timezone: timezone)
        
        set.insert(DateComponents(timeZone: TimeZone.current, year: 2023, month: 4, day: 24))
        set.insert(DateComponents(timeZone: TimeZone.current, year: 2023, month: 4, day: 25))
        set.insert(DateComponents(timeZone: TimeZone.current, year: 2023, month: 4, day: 26))
        set.insert(DateComponents(timeZone: TimeZone.current, year: 2023, month: 4, day: 27))
        set.insert(DateComponents(timeZone: TimeZone.current, year: 2023, month: 4, day: 28))
        
        //Then
        XCTAssertEqual(result.count, 5)
        XCTAssertEqual(result, set)
    }
    
    func test_ChartViewModel_getDateComponents_oneMonth() throws {
        //Given
        let symbol: String = "AAPL"
        let exchange: String = "NASDAQ"
        var set = Set<DateComponents>()
        let vm = ChartViewModel(symbol: symbol, exchange: exchange, chartService: MockChartService(symbol: symbol))
        
        //When
        vm.selectedType = .oneMonth
        let startDate = vm.stringToDate(dateString: "2023-03-25 9:30:00") ?? Date()
        let endDate = vm.stringToDate(dateString: "2023-04-25 16:00:00") ?? Date()
        let timezone = TimeZone(abbreviation: "EST") ?? TimeZone.gmt
        let result = vm.getDateComponents(startDate: startDate, endDate: endDate, timezone: timezone)
        
        set.insert(DateComponents(timeZone: TimeZone.current, year: 2023, month: 3, day: 25))
        set.insert(DateComponents(timeZone: TimeZone.current, year: 2023, month: 4, day: 1))
        set.insert(DateComponents(timeZone: TimeZone.current, year: 2023, month: 4, day: 8))
        set.insert(DateComponents(timeZone: TimeZone.current, year: 2023, month: 4, day: 15))
        set.insert(DateComponents(timeZone: TimeZone.current, year: 2023, month: 4, day: 22))
        
        //Then
        XCTAssertEqual(result.count, 5)
        XCTAssertEqual(result, set)
    }
    
    func test_ChartViewModel_getDateComponents_oneYear() throws {
        //Given
        let symbol: String = "AAPL"
        let exchange: String = "NASDAQ"
        var set = Set<DateComponents>()
        let vm = ChartViewModel(symbol: symbol, exchange: exchange, chartService: MockChartService(symbol: symbol))
        
        //When
        vm.selectedType = .oneYear
        let startDate = vm.stringToDate(dateString: "2022-04-25") ?? Date()
        let endDate = vm.stringToDate(dateString: "2023-04-25") ?? Date()
        let timezone = TimeZone(abbreviation: "EST") ?? TimeZone.gmt
        let result = vm.getDateComponents(startDate: startDate, endDate: endDate, timezone: timezone)
        
        set.insert(DateComponents(timeZone: TimeZone.current, year: 2022, month: 4))
        set.insert(DateComponents(timeZone: TimeZone.current, year: 2022, month: 8))
        set.insert(DateComponents(timeZone: TimeZone.current, year: 2022, month: 12))
        set.insert(DateComponents(timeZone: TimeZone.current, year: 2023, month: 4))
        
        
        //Then
        XCTAssertEqual(result.count, 4)
        XCTAssertEqual(result, set)
    }
    
    func test_ChartViewModel_StringToDate_DateAndTime() throws {
        //Given
        let symbol: String = "AAPL"
        let exchange: String = "NASDAQ"
        let vm = ChartViewModel(symbol: symbol, exchange: exchange, chartService: MockChartService(symbol: symbol))
        
        //When
        let result = vm.stringToDate(dateString: "2002-01-22 01:00:00")
        
        //Then
        XCTAssertNotNil(result)
    }
    
    func test_ChartViewModel_StringToDate_DateOnly() throws {
        //Given
        let symbol: String = "AAPL"
        let exchange: String = "NASDAQ"
        let vm = ChartViewModel(symbol: symbol, exchange: exchange, chartService: MockChartService(symbol: symbol))
        
        //When
        vm.selectedType = .oneYear
        let result = vm.stringToDate(dateString: "2002-01-22")
        
        //Then
        XCTAssertNotNil(result)
    }
    
    func test_ChartViewModel_StringToDate_InvalidData() throws {
        //Given
        let symbol: String = "AAPL"
        let exchange: String = "NASDAQ"
        let vm = ChartViewModel(symbol: symbol, exchange: exchange, chartService: MockChartService(symbol: symbol))
        
        //When
        let result = vm.stringToDate(dateString: "2002-01")
        
        //Then
        XCTAssertNil(result)
    }
}
