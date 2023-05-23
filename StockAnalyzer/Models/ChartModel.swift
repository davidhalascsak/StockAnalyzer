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
}


enum ChartOptions: String {
    case oneDay = "1D", oneWeek = "1W", oneMonth = "1M", oneYear = "1Y"
}

