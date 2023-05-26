import XCTest

@testable import StockAnalyzer

final class BarChartViewModel_Tests: XCTestCase {
    func test_BarChartViewModel_calculateGrowthRates_ShouldBeEmpty() throws {
        //Given
        let isInverted: Bool = Bool.random()
        let title: String = "Income"
        let vm = BarChartViewModel(title: title, xData: [], yData: [], intervals: [], isInverted: isInverted, reversePrefix: false)
        
        //When
        vm.calculateGrowthRates()
        
        //Then
        XCTAssertEqual(vm.intervals.count, vm.growthRates.count)
    }
    
    func test_BarChartViewModel_calculateGrowthRates_ShouldBeNotEmpty() throws {
        //Given
        let isInverted: Bool = Bool.random()
        let title: String = "Income"
        let vm = BarChartViewModel(title: title, xData: ["2020", "2021", "2022", "2023","2024","2025","2026","2027","2028","2029","2030"], yData: [0, 1,2,3,4,5,6,7,8,-9,-9], intervals: [1,3,5,10], isInverted: isInverted, reversePrefix: false)
        
        //When
        vm.calculateGrowthRates()
        
        //Then
        XCTAssertEqual(vm.intervals.count, vm.growthRates.count)
    }
    
    func test_BarChartViewModel_IsPRefixDifferent_ShouldBeTrue() {
        // Given
        let isInverted: Bool = Bool.random()
        let title: String = "Income"
        let vm = BarChartViewModel(title: title, xData: ["2020", "2021", "2022", "2023","2024","2025","2026","2027","2028","2029","2030"], yData: [0, 1,2,3,4,5,6,7,8,-9,-9], intervals: [1,3,5,10], isInverted: isInverted, reversePrefix: false)
        
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
        let vm = BarChartViewModel(title: title, xData: ["2020", "2021", "2022", "2023","2024","2025","2026","2027","2028","2029","2030"], yData: [0, 1,2,3,4,5,6,7,8,-9,-9], intervals: [1,3,5,10], isInverted: isInverted, reversePrefix: false)
        
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
        XCTAssertEqual("0", num1.formattedPrice)
        XCTAssertEqual("-1.00B", num2.formattedPrice)
        XCTAssertEqual("-10000", num3.formattedPrice)
        XCTAssertEqual("100", num4.formattedPrice)
        XCTAssertEqual("1000", num5.formattedPrice)
        XCTAssertEqual("10000", num6.formattedPrice)
        XCTAssertEqual("1.00M", num7.formattedPrice)
        XCTAssertEqual("10.00B", num8.formattedPrice)
        XCTAssertEqual("100.00B", num9.formattedPrice)
        XCTAssertEqual("1.00T", num10.formattedPrice)
    }
}
