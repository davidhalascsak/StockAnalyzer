import SwiftUI
import Charts

struct BarChartView: View {
    @StateObject var vm: BarChartViewModel
    
    init(title: String, xData: [String], yData: [Int], isInverted: Bool) {
        _vm = StateObject(wrappedValue: BarChartViewModel(title: title, xData: xData, yData: yData, isInverted: isInverted))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            headerView
            chartView
            growthRateView
        }
        .frame(height: 300)
        .frame(maxWidth: .infinity)
        .padding(5)
        .padding(.top, 5)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
    
    var headerView: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline) {
                Text(vm.formatPrice(price:  vm.yData[vm.selectedDate ?? (vm.yData.count - 1)]))
                    .foregroundColor(vm.yData[vm.selectedDate ?? (vm.yData.count - 1)] >= 0 ? Color.blue : Color.red)
                    .font(.title)
                    .fontWeight(.bold)
                Text(vm.xData[vm.selectedDate ?? (vm.yData.count - 1)][0...3])
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            Text(vm.title)
                .font(.title2)
        }
    }
    
    var chartView: some View {
        VStack {
            Chart {
                ForEach(Array(zip(vm.xData, vm.yData)), id: \.0) { year, data in
                    BarMark(
                        x: .value("Year", year),
                        y: .value("Revenue", data),
                        width: 18,
                        stacking: .standard)
                    .foregroundStyle(year == vm.xData[vm.xData.count - 1] ? Color.blue : data > 0 ? Color.gray : Color.red)
                    .opacity(vm.xData[vm.selectedDate ?? (vm.yData.count - 1)] == year ? 0.7 : 1.0)
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
                                   vm.selectedDate = vm.xData.firstIndex(of: index) ?? nil
                               }
                               .onEnded { _ in
                                   vm.selectedDate = nil
                               }
                       )
                }
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
        }
    }

    var growthRateView: some View {
        VStack(alignment: .leading) {
            Text("Growth rates")
                .font(.title3)
                .fontWeight(.bold)
            VStack(alignment: .leading) {
                HStack {
                    GrowthRateView(year: 1, growthRate: vm.growthRates[0], isInverted: vm.isInverted)
                    GrowthRateView(year: 3, growthRate: vm.growthRates[1], isInverted: vm.isInverted)
                }
                HStack {
                    GrowthRateView(year: 5, growthRate: vm.growthRates[2], isInverted: vm.isInverted)
                    GrowthRateView(year: 10, growthRate: vm.growthRates[3], isInverted: vm.isInverted)
                }
            }
        }
        .padding(.top, 10)
    }
}

struct BarChartView_Previews: PreviewProvider {
    static var previews: some View {
        BarChartView(title: "Revenue", xData: ["2021", "2022", "2023","2024","2025","2026","2027","2028","2029","2030"], yData: [1,2,3,4,5,6,7,8,-9,-9], isInverted: false)
    }
}
