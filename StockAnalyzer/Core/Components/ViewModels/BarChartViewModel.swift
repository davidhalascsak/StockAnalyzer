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
                    print(growthRate)
                    
                    growthRateAsString = String(format: "%2.f", growthRate)
                    growthRateAsString = growthRateAsString[0] == "-" ? "\(growthRateAsString)%" : growthRateAsString == "0.0" ?  "\(growthRateAsString)%" : "+\(growthRateAsString)%"
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
    
    func formatPrice(price: Int) -> String {
        var priceAsString: String = String(price)
        var prefix = ""
        var result: String
        
        if price < 0 {
            prefix = "-"
            priceAsString = priceAsString.trimmingCharacters(in: CharacterSet(charactersIn: "-"))
        }
        
        if priceAsString.count % 3 == 0 {
            if priceAsString.count >= 6 {
                result = "\(priceAsString[0...2]).\(priceAsString[3...4])"
            } else {
                result = priceAsString
            }
        } else if priceAsString.count % 3 == 1 {
            if priceAsString.count >= 7 {
                result = "\(priceAsString[0]).\(priceAsString[1...2])"
            } else {
                result = priceAsString
            }
        } else {
            if priceAsString.count >= 8 {
                result = "\(priceAsString[0...1]).\(priceAsString[2...3])"
            } else {
                result = priceAsString
            }
        }
        
        if priceAsString.count >= 7 && priceAsString.count < 10 {
            result.append("M")
        } else if 10 <= priceAsString.count && priceAsString.count < 13 {
            result.append("B")
        } else if priceAsString.count >= 13 {
            result.append("T")
        }
        
        return "\(prefix)\(result)"
    }
}
