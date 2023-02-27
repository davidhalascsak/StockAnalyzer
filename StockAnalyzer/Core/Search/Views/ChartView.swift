import SwiftUI
import Charts

struct ChartView: View {
    @StateObject var vm: ChartViewModel
    
    init(symbol: String) {
        _vm = StateObject(wrappedValue: ChartViewModel(symbol: symbol))
    }
    var body: some View {
        
        VStack {
            if vm.isLoading == false {
                Chart(vm.dailyData, id: \.self) { elem in
                    LineMark(
                        x: .value("Hour", vm.createDate(dateString: elem.date), unit: .minute),
                        y: .value("Price", elem.close)
                    )
                }
                .chartYScale(domain: vm.minPrice!...vm.maxPrice!)
                
            } else {
                ProgressView()
            }
        }
        .frame(height: 150)
        .frame(maxWidth: .infinity)
        .padding()
        
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(symbol: "AAPL")
    }
}



