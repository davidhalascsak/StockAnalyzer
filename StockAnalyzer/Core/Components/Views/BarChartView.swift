import SwiftUI
import Charts

struct BarChartView: View {
    @State var xData: [String] = []
    @State var yData: [Int] = []
    @State var selectedDate: Int? = nil
    
    let title: String
    var growthRates: [String] = []
    let isInverted: Bool
    
    init(title: String, xData: [String], yData: [Int], isInverted: Bool) {
        self.title = title
        self.xData = xData
        self.yData = yData
        self.isInverted = isInverted
        self.growthRates = self.calculateGrowthRates(data: yData)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline) {
                Text(formatPrice(price:  yData[selectedDate ?? (yData.count - 1)]))
                    .foregroundColor(yData[selectedDate ?? (yData.count - 1)] >= 0 ? Color.blue : Color.red)
                    .font(.title)
                    .fontWeight(.bold)
                Text(xData[selectedDate ?? (yData.count - 1)][0...3])
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            Text(self.title)
                .font(.title2)
            Chart {
                ForEach(Array(zip(xData, yData)), id: \.0) { year, data in
                    BarMark(
                        x: .value("Year", year),
                        y: .value("Revenue", data),
                        width: 18,
                        stacking: .standard)
                    .foregroundStyle(year == xData[xData.count - 1] ? Color.blue : data > 0 ? Color.gray : Color.red)
                    .opacity(xData[selectedDate ?? (yData.count - 1)] == year ? 0.7 : 1.0)
                    .cornerRadius(40)
                }
            }
            .chartOverlay { chart in
                GeometryReader { geometry in
                    Rectangle()
                       .fill(Color.clear)
                       .contentShape(Rectangle())
                       .gesture(
                           DragGesture()
                               .onChanged { value in
                                   let currentX = value.location.x - geometry[chart.plotAreaFrame].origin.x
                                   
                                   guard currentX >= 0, currentX < chart.plotAreaSize.width else {return}
                                   guard let index = chart.value(atX: currentX, as: String.self) else {return}
                                   selectedDate = xData.firstIndex(of: index) ?? nil
                               }
                               .onEnded { _ in
                                   selectedDate = nil
                               }
                       )
                }
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            
            VStack(alignment: .leading) {
                Text("Growth rates")
                    .font(.title3)
                    .fontWeight(.bold)
                growthRateView
            }
            .padding(.top, 10)
        }
        .frame(height: 300)
        .frame(maxWidth: .infinity)
        .padding(5)
        .padding(.top, 5)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }

    var growthRateView: some View {
        VStack(alignment: .leading) {
            HStack {
                HStack {
                    Text("1 year: ")
                        .fontWeight(.semibold)
                    if self.isInverted {
                        Text(growthRates[0])
                            .foregroundColor(growthRates[0] == "-" ? Color.black : growthRates[0][0] == "-" ? Color.green : Color.red)
                    } else {
                        Text(growthRates[0])
                            .foregroundColor(growthRates[0] == "-" ? Color.black : growthRates[0][0] == "-" ? Color.red : Color.green)
                    }
                }
                .padding(5)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 2)
                }
                HStack {
                    Text("3 years: ")
                        .fontWeight(.semibold)
                    if self.isInverted {
                        Text(growthRates[1])
                            .foregroundColor(growthRates[1] == "-" ? Color.black : growthRates[1][0] == "-" ? Color.green : Color.red)
                    } else {
                        Text(growthRates[1])
                            .foregroundColor(growthRates[1] == "-" ? Color.black : growthRates[1][0] == "-" ? Color.red : Color.green)
                    }
                }
                .padding(5)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 2)
                }
            }
            HStack {
                HStack {
                    Text("5 years: ")
                        .fontWeight(.semibold)
                    if self.isInverted {
                        Text(growthRates[2])
                            .foregroundColor(growthRates[2] == "-" ? Color.black : growthRates[2][0] == "-" ? Color.green : Color.red)
                    } else {
                        Text(growthRates[2])
                            .foregroundColor(growthRates[2] == "-" ? Color.black : growthRates[2][0] == "-" ? Color.red : Color.green)
                    }
                }
                .padding(5)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 2)
                }
                HStack {
                    Text("10 years: ")
                        .fontWeight(.semibold)
                    if self.isInverted {
                        Text(growthRates[3])
                            .foregroundColor(growthRates[3] == "-" ? Color.black : growthRates[3][0] == "-" ? Color.green : Color.red)
                    } else {
                        Text(growthRates[3])
                            .foregroundColor(growthRates[3] == "-" ? Color.black : growthRates[3][0] == "-" ? Color.red : Color.green)
                    }
                }
                .padding(5)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 2)
                }
            }
        }
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
        
        if (data.count - 1) >= 0 && (data.count - 4) >= 0 {
            let multiplier = data[data.count - 1] >= 0 ? 1.0 : -1.0
            
            threeYear = String(format: "%.1f", multiplier * (pow(Double(data[data.count - 1]) / Double(data[data.count - 4]), 1.0/3.0) - 1.0) * 100)
            
            if threeYear == "nan" || self.checkNums(lfs: data[data.count - 1], rfs: data[data.count - 4]) {
                threeYear = "-"
            } else {
                threeYear = threeYear[0] == "-" ? "\(threeYear)%" : "+\(threeYear)%"
            }
        } else {
            threeYear = "-"
        }
        
        if (data.count - 1) >= 0 && (data.count - 6) >= 0 {
            let multiplier = data[data.count - 1] >= 0 ? 1.0 : -1.0
            
            fiveYear = String(format: "%.1f", multiplier * (pow(Double(data[data.count - 1]) / Double(data[data.count - 6]), 1.0/5.0) - 1.0) * 100)
            
            if fiveYear == "nan" || self.checkNums(lfs: data[data.count - 1], rfs: data[data.count - 6]) {
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
}

struct BarChartView_Previews: PreviewProvider {
    static var previews: some View {
        BarChartView(title: "Revenue", xData: ["2021", "2022", "2023","2024","2025","2026","2027","2028","2029","2030"], yData: [1,2,3,4,5,6,7,8,-9,-9], isInverted: false)
    }
}
