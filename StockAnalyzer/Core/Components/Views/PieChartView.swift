import SwiftUI

public struct PieChartView: View {
    public let values: [Int]
    public let names: [String]
    public let formatter: (Int) -> String
    
    public var colors: [Color]
    
    public var widthFraction: CGFloat
    public var innerRadiusFraction: CGFloat
    
    @State private var activeIndex: Int = -1
    
    var slices: [PieSliceData] {
        let sum: Int = values.reduce(0, +)
        var endDeg: Double = 0
        var tempSlices: [PieSliceData] = []
        
        for (i, value) in values.enumerated() {
            let degrees: Double = Double(value) * 360 / Double(sum)
            tempSlices.append(PieSliceData(startAngle: Angle(degrees: endDeg), endAngle: Angle(degrees: endDeg + degrees), color: self.colors[i]))
            endDeg += degrees
        }
        return tempSlices
    }
    
    public init(values:[Int], names: [String], formatter: @escaping (Int) -> String, colors: [Color] = [Color.blue, Color.green, Color.orange], widthFraction: CGFloat = 1.0, innerRadiusFraction: CGFloat = 0.70){
        self.values = values
        self.names = names
        self.formatter = formatter
        
        self.colors = colors
        self.widthFraction = widthFraction
        self.innerRadiusFraction = innerRadiusFraction
    }
    
    public var body: some View {
        VStack{
            GeometryReader { geometry in
                ZStack{
                    ForEach(0..<self.values.count, id: \.self){ i in
                        PieSlice(pieSliceData: self.slices[i])
                            .scaleEffect(self.activeIndex == i ? 1.03 : 1)
                    }
                    .frame(width: widthFraction * geometry.size.width, height: widthFraction * geometry.size.width)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let radius = 0.5 * widthFraction * geometry.size.width
                                let diff = CGPoint(x: value.location.x - radius, y: radius - value.location.y)
                                let dist = pow(pow(diff.x, 2.0) + pow(diff.y, 2.0), 0.5)
                                if (dist > radius || dist < radius * innerRadiusFraction) {
                                    self.activeIndex = -1
                                    return
                                }
                                var radians = Double(atan2(diff.x, diff.y))
                                if (radians < 0) {
                                    radians = 2 * Double.pi + radians
                                }
                                
                                for (i, slice) in slices.enumerated() {
                                    if (radians < slice.endAngle.radians) {
                                        self.activeIndex = i
                                        break
                                    }
                                }
                            }
                            .onEnded { value in
                                self.activeIndex = -1
                            }
                    )
                    Circle()
                        .fill(Color.white)
                        .frame(width: widthFraction * geometry.size.width * innerRadiusFraction, height: widthFraction * geometry.size.width * innerRadiusFraction)
                    
                    VStack {
                        Text(self.activeIndex == -1 ? "Total Equity" : names[self.activeIndex])
                            .font(.title2)
                        Text(self.formatter(self.activeIndex == -1 ? (values[0] - values[1]) : values[self.activeIndex]))
                            .font(.title2)
                    }
                }
            }
            .frame(width: 250, height: 250)
        }
    }
}

struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        PieChartView(values: [1300, 500, 300], names: ["Rent", "Transport", "Education"], formatter: {value in String(format: "$%.0f", value)})
    }
}


