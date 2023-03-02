import SwiftUI
import Charts

struct ChartView: View {
    @StateObject var vm: ChartViewModel
    @State var selectedType: ChartOption = .oneDay
    
    init(symbol: String) {
        _vm = StateObject(wrappedValue: ChartViewModel(symbol: symbol))
    }
    var body: some View {
        VStack {
            if vm.isLoading == false {
                Text(vm.selectedType.rawValue)
                chartView
                Picker("ChartOptions", selection: $vm.selectedType) {
                    ForEach(ChartOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                
            } else {
                ProgressView()
            }
        }
        .onChange(of: vm.selectedType, perform: { _ in
            vm.fetchData()
        })
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    var chartView: some View {
        Chart(vm.chartData.reversed(), id: \.self) { elem in
            LineMark(
                x: .value("Date", elem.date),
                y: .value("Price", elem.open)
            )
        }
        .chartYScale(domain: vm.minValues[vm.selectedType.rawValue]!...vm.maxValues[vm.selectedType.rawValue]!)
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(symbol: "AAPL")
    }
}



