import SwiftUI

struct PieChartView: View {
    let slices: [Int]

    var body: some View {
        Canvas { context, size in
            let total = slices.reduce(0, { x, y in
                x + y
            })
            
            context.translateBy(x: size.width * 0.5, y: size.height * 0.5)
            var pieContext = context
            pieContext.rotate(by: .degrees(-90))
            let radius = min(size.width, size.height) * 0.48
            var startAngle = Angle.zero
            for value in slices {
                let angle = Angle(degrees: Double(360 * (value / total)))
                let endAngle = startAngle + angle
                let path = Path { p in
                    p.move(to: .zero)
                    p.addArc(center: .zero, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
                    p.closeSubpath()
                }
                pieContext.fill(path, with: .color(Color.blue))
                startAngle = endAngle
            }
        }
        .frame(width: 300, height: 200)
        .border(Color.blue)
        //.aspectRatio(1, contentMode: .fit)
    }
}



struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        PieChartView(slices: [2,3,4,5])
    }
}

