import Foundation

class BarChartViewModel: ObservableObject {
    @Published var xData: [String] = []
    @Published var yData: [Int] = []
    @Published var growthRates: [String] = []
    @Published var selectedDate: Int?
    
    let title: String
    let isInverted: Bool
    
    init(title: String, xData: [String], yData: [Int], isInverted: Bool) {
        self.title = title
        self.xData = xData
        self.yData = yData
        self.isInverted = isInverted
        self.growthRates = self.calculateGrowthRates(data: yData)
    }

    func calculateGrowthRates(data: [Int]) -> [String] {
        var oneYear: String = ""
        var threeYear: String = ""
        var fiveYear: String = ""
        var tenYear: String = ""
        
        if (data.count - 1) >= 0 && (data.count - 2) >= 0 {
            let multiplier = data[data.count - 1] >= 0 ? 1.0 : -1.0
            
            oneYear = String(format: "%.1f", multiplier * (pow(Double(data[data.count - 1]) / Double(data[data.count - 2]), 1.0/1.0) - 1.0) * 100)
            
            if oneYear == "nan" || self.checkNums(lfs: data[data.count - 1], rfs: data[data.count - 2]) {
                oneYear = "-"
            } else {
                oneYear = oneYear[0] == "-" ? "\(oneYear)%" : "+\(oneYear)%"
            }
        } else {
            oneYear = "-"
        }
        
        if (data.count - 1) >= 0 && (data.count - 3) >= 0 {
            let multiplier = data[data.count - 1] >= 0 ? 1.0 : -1.0
            
            threeYear = String(format: "%.1f", multiplier * (pow(Double(data[data.count - 1]) / Double(data[data.count - 3]), 1.0/3.0) - 1.0) * 100)
            
            if threeYear == "nan" || self.checkNums(lfs: data[data.count - 1], rfs: data[data.count - 3]) {
                threeYear = "-"
            } else {
                threeYear = threeYear[0] == "-" ? "\(threeYear)%" : "+\(threeYear)%"
            }
        } else {
            threeYear = "-"
        }
        
        if (data.count - 1) >= 0 && (data.count - 5) >= 0 {
            let multiplier = data[data.count - 1] >= 0 ? 1.0 : -1.0
            
            fiveYear = String(format: "%.1f", multiplier * (pow(Double(data[data.count - 1]) / Double(data[data.count - 5]), 1.0/5.0) - 1.0) * 100)
            
            if fiveYear == "nan" || self.checkNums(lfs: data[data.count - 1], rfs: data[data.count - 5]) {
                fiveYear = "-"
            } else {
                fiveYear = fiveYear[0] == "-" ? "\(fiveYear)%" : "+\(fiveYear)%"
            }
        } else {
            fiveYear = "-"
        }
        
        if (data.count - 1) >= 0 && (data.count - 10) >= 0 {
            let multiplier = data[data.count - 1] >= 0 ? 1.0 : -1.0
            
            tenYear = String(format: "%.1f", multiplier * (pow(Double(data[data.count - 1]) / Double(data[data.count - 10]), 1.0/10.0) - 1.0) * 100)
            
            if tenYear == "nan" || self.checkNums(lfs: data[data.count - 1], rfs: data[data.count - 10]) {
                tenYear = "-"
            } else {
                tenYear = tenYear[0] == "-" ? "\(tenYear)%" : "+\(tenYear)%"
            }
        } else {
            tenYear = "-"
        }
         

        return [oneYear, threeYear, fiveYear, tenYear]
    }
    
    func checkNums(lfs: Int, rfs: Int) -> Bool {
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
            result = "\(priceAsString[0...2]).\(priceAsString[3...4])"
        } else if priceAsString.count % 3 == 1 {
            result = "\(priceAsString[0]).\(priceAsString[1...2])"
        } else {
            result = "\(priceAsString[0...1]).\(priceAsString[2...3])"
        }
        
        if priceAsString.count < 10 {
            result.append("M")
        } else if 10 <= priceAsString.count && priceAsString.count < 13 {
            result.append("B")
        } else {
            result.append("T")
        }
        
        return "\(prefix)\(result)"
    }
}
