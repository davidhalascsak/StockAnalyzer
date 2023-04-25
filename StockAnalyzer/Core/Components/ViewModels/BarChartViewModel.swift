import Foundation

class BarChartViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var xData: [String] = []
    @Published var yData: [Int] = []
    @Published var growthRates: [String] = []
    @Published var selectedDate: Int?
    
    let title: String
    let isInverted: Bool
    let intervals: [Int]
    
    init(title: String, xData: [String], yData: [Int], intervals: [Int], isInverted: Bool) {
        self.title = title
        self.xData = xData
        self.yData = yData
        self.intervals = intervals
        self.isInverted = isInverted
    }

    func calculateGrowthRates() {
        
        for interval in self.intervals {
            if (self.yData.count - interval - 1) >= 0 {
                var growthRate = String(format: "%.1f", (pow(Double(self.yData[self.yData.count - 1]) / Double(self.yData[self.yData.count - interval - 1]), 1.0/1.0) - 1.0) * 100)
                
                
                if growthRate == "nan" || self.isPrefixDifferent(lfs: self.yData[self.yData.count - 1], rfs: self.yData[self.yData.count - interval - 1]) {
                    growthRate = "-"
                } else {
                    growthRate = growthRate[0] == "-" ? "\(growthRate)%" : growthRate == "0.0" ?  "\(growthRate)%" : "+\(growthRate)%"
                }
                
                self.growthRates.append(growthRate)
            } else {
                self.growthRates.append("")
            }
        }
        self.isLoading = false
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
