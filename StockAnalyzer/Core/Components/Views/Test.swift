import SwiftUI

struct Test: View {
    var body: some View {
        VStack {
            PieChartView(slices: [2,3,4,5])
        }
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
