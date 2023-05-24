import Foundation

class BarChartViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var xData: [String] = []
    @Published var yData: [Int] = []
    @Published var growthRates: [String] = []
    @Published var selectedDate: Int?
    
    let title: String
    let isInverted: Bool
    let reversePrefix: Bool
    let intervals: [Int]
    
    init(title: String, xData: [String], yData: [Int], intervals: [Int], isInverted: Bool, reversePrefix: Bool) {
        self.title = title
        self.xData = xData
        self.yData = yData
        self.intervals = intervals
        self.isInverted = isInverted
        self.reversePrefix = reversePrefix
    }

    func calculateGrowthRates() {
        for interval in intervals {
            if (yData.count - interval - 1) >= 0 {
                var growthRateAsString = "-"
                if !isPrefixDifferent(lfs: yData[yData.count - 1], rfs: yData[yData.count - interval - 1]) {
                    let difference = pow(Double(yData[yData.count - 1]) / Double(yData[yData.count - interval - 1]), 1.0/Double(interval))
                    
                    let growthRate: Double
                    
                    if !reversePrefix && yData[yData.count - 1] < 0 {
                        growthRate = (1 - difference) * 100.0
                    } else {
                        growthRate = (difference - 1) * 100.0
                    }

                    growthRateAsString = String(format: "%.0f", growthRate)
                    growthRateAsString = growthRateAsString == "-" ? growthRateAsString : (growthRateAsString.contains("0") ? "\(growthRateAsString)%" : (growthRateAsString[0] == "-" ? "\(growthRateAsString)%" : "+\(growthRateAsString)%"))
                }
                
                growthRates.append(growthRateAsString)
            } else {
                growthRates.append("")
            }
        }
        isLoading = false
    }
    
    func isPrefixDifferent(lfs: Int, rfs: Int) -> Bool {
        if lfs <= 0 && rfs >= 0 {
            return true
        } else if lfs >= 0 && rfs <= 0 {
            return true
        }
        return false
    }
}
