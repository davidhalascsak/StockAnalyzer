import SwiftUI
import Charts

struct ChartView: View {
    @StateObject var viewModel: ChartViewModel
    
    init(stockSymbol: String, exchange: String, chartService: ChartServiceProtocol) {
        _viewModel = StateObject(wrappedValue: ChartViewModel(stockSymbol: stockSymbol, exchange: exchange, chartService: chartService))
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading == false {
                chartView
            } else {
                ProgressView()
                    .frame(height: 150)
            }
            chartOptionPickerView
                .padding(.vertical, 5)
                .onChange(of: viewModel.selectedType, perform: { _ in
                    Task {
                        await viewModel.fetchData()
                    }
                })
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .padding()
        .onAppear {
            Task {
                await viewModel.fetchData()
            }
        }
    }
    
    var chartView: some View {
        Chart {
            ForEach(Array(zip(viewModel.chartData.indices, viewModel.chartData)), id: \.0) { index, item in
                LineMark(
                    x: .value("Time", index),
                    y: .value("Price", item.open)
                )
                
                AreaMark(x: .value("Time", index), yStart: .value("Min", viewModel.minValues[viewModel.selectedType.rawValue]!), yEnd: .value("Max", item.open))
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
        .chartXScale(domain: (viewModel.xAxisData?.axisStart ?? 0.0)...(viewModel.xAxisData?.axisEnd ?? 0.0))
        .chartYScale(domain: (viewModel.yAxisData?.axisStart ?? 0.0)...(viewModel.yAxisData?.axisEnd ?? 0.0))
        .chartPlotStyle { chartPlotStyle($0) }
    }
    
    var chartOptionPickerView: some View {
        HStack(spacing: 30) {
            Text("1D")
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                .fontWeight(viewModel.selectedType == .oneDay ? .bold : nil)
                .background(viewModel.selectedType == .oneDay ? Color.gray.opacity(0.2).cornerRadius(20) : nil)
                .onTapGesture {
                    viewModel.isLoading = true
                    viewModel.selectedType = .oneDay
                }
            Text("1W")
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                .fontWeight(viewModel.selectedType == .oneWeek ? .semibold : nil)
                .background(viewModel.selectedType == .oneWeek ? Color.gray.opacity(0.2).cornerRadius(20) : nil)
                .onTapGesture {
                    viewModel.isLoading = true
                    viewModel.selectedType = .oneWeek
                }
            Text("1M")
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                .fontWeight(viewModel.selectedType == .oneMonth ? .semibold : nil)
                .background(viewModel.selectedType == .oneMonth ? Color.gray.opacity(0.2).cornerRadius(20) : nil)
                .onTapGesture {
                    viewModel.isLoading = true
                    viewModel.selectedType = .oneMonth
                }
            Text("1Y")
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                .fontWeight(viewModel.selectedType == .oneYear ? .semibold : nil)
                .background(viewModel.selectedType == .oneYear ? Color.gray.opacity(0.2).cornerRadius(20) : nil)
                .onTapGesture {
                    viewModel.isLoading = true
                    viewModel.selectedType = .oneYear
                }
        }
    }
    
    var chartXAxis: some AxisContent {
        AxisMarks(values: .stride(by: viewModel.xAxisData?.strideBy ?? 1)) { value in
            if let text = viewModel.xAxisData?.map[String(value.index)] {
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
        AxisMarks(preset: .extended, values: .stride(by: viewModel.yAxisData?.strideBy ?? 1)) { value in
            if let y = value.as(Double.self), let text = viewModel.yAxisData?.map[y.roundedString] {
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
        ChartView(stockSymbol: "AAPL", exchange: "NASDAQ", chartService: MockChartService(stockSymbol: "AAPL"))
    }
}



