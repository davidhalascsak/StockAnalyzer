import Foundation
import SwiftUI
    
struct ChartAxisData {
    let axisStart: Double
    let axisEnd: Double
    let strideBy: Double
    let map: [String: String]
}

struct PieSliceData {
    var startAngle: Angle
    var endAngle: Angle
    var color: Color
    
    var midRadians: Double {
        return Double.pi / 2.0 - (startAngle + endAngle).radians / 2.0
    }
}

enum ChartOption: String {
    case oneDay = "1D", oneWeek = "1W", oneMonth = "1M", oneYear = "1Y"
}
