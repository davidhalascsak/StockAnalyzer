import XCTest

@testable import StockAnalyzer

final class BarChartViewModel_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_BarChartViewModel_init_IsInverted() throws {
        //Given
        let isInverted: Bool = Bool.random()
        let title: String = "Income"
        
        //When
        let vm = BarChartViewModel(title: title, xData: ["2020", "2021", "2022", "2023","2024","2025","2026","2027","2028","2029","2030"], yData: [0, 1,2,3,4,5,6,7,8,-9,-9], intervals: [1,3,5,10], isInverted: isInverted)
        
        //Then
        XCTAssertEqual(isInverted, vm.isInverted)
    }
    
    func test_BarChartViewModel_init_title() throws {
        //Given
        let isInverted: Bool = Bool.random()
        let title: String = "Income"
        
        //When
        let vm = BarChartViewModel(title: title, xData: ["2020", "2021", "2022", "2023","2024","2025","2026","2027","2028","2029","2030"], yData: [0, 1,2,3,4,5,6,7,8,-9,-9], intervals: [1,3,5,10], isInverted: isInverted)
        
        //Then
        XCTAssertEqual(title, vm.title)
    }
    
    func test_BarChartViewModel_calculateGrowthRates_ShouldBeEmpty() throws {
        //Given
        let isInverted: Bool = Bool.random()
        let title: String = "Income"
        let vm = BarChartViewModel(title: title, xData: [], yData: [], intervals: [], isInverted: isInverted)
        
        //When
        vm.calculateGrowthRates()
        
        //Then
        XCTAssertEqual(vm.intervals.count, vm.growthRates.count)
    }
    
    func test_BarChartViewModel_calculateGrowthRates_ShouldBeNotEmpty() throws {
        //Given
        let isInverted: Bool = Bool.random()
        let title: String = "Income"
        let vm = BarChartViewModel(title: title, xData: ["2020", "2021", "2022", "2023","2024","2025","2026","2027","2028","2029","2030"], yData: [0, 1,2,3,4,5,6,7,8,-9,-9], intervals: [1,3,5,10], isInverted: isInverted)
        
        //When
        vm.calculateGrowthRates()
        
        //Then
        XCTAssertEqual(vm.intervals.count, vm.growthRates.count)
    }
    
    func test_BarChartViewModel_IsPRefixDifferent_ShouldBeTrue() {
        // Given
        let isInverted: Bool = Bool.random()
        let title: String = "Income"
        let vm = BarChartViewModel(title: title, xData: ["2020", "2021", "2022", "2023","2024","2025","2026","2027","2028","2029","2030"], yData: [0, 1,2,3,4,5,6,7,8,-9,-9], intervals: [1,3,5,10], isInverted: isInverted)
        
        //When
        let num1 = -1
        let num2 = 1
        let num3 = 0
        
        //Then
        XCTAssertTrue(vm.isPrefixDifferent(lfs: num1, rfs: num2))
        XCTAssertTrue(vm.isPrefixDifferent(lfs: num1, rfs: num3))
        XCTAssertTrue(vm.isPrefixDifferent(lfs: num3, rfs: num2))
    }
    
    func test_BarChartViewModel_IsPRefixDifferent_ShouldBeFalse() {
        // Given
        let isInverted: Bool = Bool.random()
        let title: String = "Income"
        let vm = BarChartViewModel(title: title, xData: ["2020", "2021", "2022", "2023","2024","2025","2026","2027","2028","2029","2030"], yData: [0, 1,2,3,4,5,6,7,8,-9,-9], intervals: [1,3,5,10], isInverted: isInverted)
        
        //When
        let num1 = 1
        let num2 = 2
        let num3 = -1
        let num4 = -2
        
        //Then
        XCTAssertFalse(vm.isPrefixDifferent(lfs: num1, rfs: num2))
        XCTAssertFalse(vm.isPrefixDifferent(lfs: num3, rfs: num4))
    }
    
    
    func test_BarChartViewModel_formatPrice() {
        // Given
        let isInverted: Bool = Bool.random()
        let title: String = "Income"
        let vm = BarChartViewModel(title: title, xData: ["2020", "2021", "2022", "2023","2024","2025","2026","2027","2028","2029","2030"], yData: [0, 1,2,3,4,5,6,7,8,-9,-9], intervals: [1,3,5,10], isInverted: isInverted)
        
        //When
        let num1 = 0
        let num2 = -1000000000
        let num3 = -10000
        let num4 = 100
        let num5 = 1000
        let num6 = 10000
        let num7 = 1000000
        let num8 = 10000000000
        let num9 = 100000000000
        let num10 = 1000000000000
        
        //Then
        XCTAssertEqual("0", vm.formatPrice(price: num1))
        XCTAssertEqual("-1.00B", vm.formatPrice(price: num2))
        XCTAssertEqual("-1.00B", vm.formatPrice(price: num2))
        XCTAssertEqual("-10000", vm.formatPrice(price: num3))
        XCTAssertEqual("100", vm.formatPrice(price: num4))
        XCTAssertEqual("1000", vm.formatPrice(price: num5))
        XCTAssertEqual("10000", vm.formatPrice(price: num6))
        XCTAssertEqual("1.00M", vm.formatPrice(price: num7))
        XCTAssertEqual("10.00B", vm.formatPrice(price: num8))
        XCTAssertEqual("100.00B", vm.formatPrice(price: num9))
        XCTAssertEqual("1.00T", vm.formatPrice(price: num10))
    }
}
