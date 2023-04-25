import SwiftUI

struct GrowthRateView: View {
    let year: Int
    let growthRate: String
    let isInverted: Bool
    
    var body: some View {
        HStack {
            Text("\(year) \(year == 1 ? "Year" : "Years"): ")
                .fontWeight(.semibold)
            if isInverted {
                Text(growthRate)
                    .foregroundColor((growthRate == "-" || growthRate == "0.0%") ? Color.black : growthRate[0] == "-" ? Color.green : Color.red)
            } else {
                Text(growthRate)
                    .foregroundColor(growthRate == "-" ? Color.black : growthRate[0] == "-" ? Color.red : Color.green)
            }
        }
        .padding(5)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 2)
        }
    }
}

struct GrowthRateView_Previews: PreviewProvider {
    static var previews: some View {
        GrowthRateView(year: 1, growthRate: "5.3%", isInverted: false)
    }
}
