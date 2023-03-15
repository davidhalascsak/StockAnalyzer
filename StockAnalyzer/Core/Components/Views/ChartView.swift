import SwiftUI
import Charts

struct ChartView: View {
    @StateObject var vm: ChartViewModel
    @State var selectedType: ChartOption = .oneDay
    
    init(symbol: String, exchange: String) {
        _vm = StateObject(wrappedValue: ChartViewModel(symbol: symbol, exchange: exchange))
    }
    var body: some View {
        VStack {
            if vm.isLoading == false {
                chartView
            } else {
                ProgressView()
                    .frame(height: 150)
            }
            chartOptionPicker
                .padding(.vertical, 5)
                .onChange(of: selectedType, perform: { _ in
                    vm.selectedType = selectedType
                    vm.fetchData()
                })
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    var chartView: some View {
        Chart {
            ForEach(Array(zip(vm.chartData.indices, vm.chartData)), id: \.0) { index, item in
                LineMark(
                    x: .value("Time", index),
                    y: .value("Price", item.open)
                )
                
                AreaMark(x: .value("Time", index), yStart: .value("Min", vm.minValues[vm.selectedType.rawValue]!), yEnd: .value("Max", item.open))
                    .foregroundStyle(LinearGradient(
                        gradient: Gradient(colors: [
                            Color.blue,
                            .clear
                        ]), startPoint: .top, endPoint: .bottom)
                    ).opacity(0.3)
            }
        }
        .chartXAxis { chartXAxis }
        .chartYAxis { chartYAxis }
        .chartXScale(domain: (vm.xAxisData!.axisStart)...(vm.xAxisData!.axisEnd))
        .chartYScale(domain: (vm.yAxisData!.axisStart)...(vm.yAxisData!.axisEnd))
        .chartPlotStyle { chartPlotStyle($0) }
    }
    
    var chartOptionPicker: some View {
        HStack(spacing: 30) {
            Text("1D")
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                .fontWeight(selectedType == .oneDay ? .bold : nil)
                .background(selectedType == .oneDay ? Color.gray.opacity(0.2).cornerRadius(20) : nil)
                .onTapGesture {
                    selectedType = .oneDay
                }
            Text("1W")
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                .fontWeight(selectedType == .oneWeek ? .semibold : nil)
                .background(selectedType == .oneWeek ? Color.gray.opacity(0.2).cornerRadius(20) : nil)
                .onTapGesture {
                    selectedType = .oneWeek
                }
            Text("1M")
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                .fontWeight(selectedType == .oneMonth ? .semibold : nil)
                .background(selectedType == .oneMonth ? Color.gray.opacity(0.2).cornerRadius(20) : nil)
                .onTapGesture {
                    selectedType = .oneMonth
                }
            Text("1Y")
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                .fontWeight(selectedType == .oneYear ? .semibold : nil)
                .background(selectedType == .oneYear ? Color.gray.opacity(0.2).cornerRadius(20) : nil)
                .onTapGesture {
                    selectedType = .oneYear
                }
        }
    }
    
    var chartXAxis: some AxisContent {
        AxisMarks(values: .stride(by: vm.xAxisData?.strideBy ?? 1)) { value in
            if let text = vm.xAxisData?.map[String(value.index)] {
                AxisGridLine(stroke: .init(lineWidth: 0.3))
                AxisTick(stroke: .init(lineWidth: 0.3))
                AxisValueLabel(collisionResolution: .greedy) {
                    Text(text)
                        .font(.caption)
                        .fontWeight(.bold)
                }
            }
        }
    }
    
    var chartYAxis: some AxisContent {
        AxisMarks(preset: .extended, values: .stride(by: vm.yAxisData?.strideBy ?? 1)) { value in
            if let y = value.as(Double.self), let text = vm.yAxisData?.map[y.roundedString] {
                AxisGridLine(stroke: .init(lineWidth: 0.3))
                AxisTick(stroke: .init(lineWidth: 0.3))
                AxisValueLabel(anchor: .topLeading, collisionResolution: .greedy) {
                    Text(text)
                        .font(.caption)
                        .fontWeight(.bold)
                }
            }
        }
    }
    
    private func chartPlotStyle(_ plotContent: ChartPlotContent) -> some View {
        plotContent
            .overlay {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.5))
                    .mask(ZStack {
                        VStack {
                            Spacer()
                            Rectangle().frame(height: 1)
                        }
                        
                        HStack {
                            Spacer()
                            Rectangle().frame(width: 0.3)
                        }
                    })
            }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(symbol: "AAPL", exchange: "NASDAQ")
    }
}



