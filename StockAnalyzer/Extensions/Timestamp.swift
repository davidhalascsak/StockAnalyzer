import Foundation
import SwiftUI
import Firebase

extension Timestamp {
    func toDateString() -> String {
        let difference = Date().timeIntervalSince(self.dateValue())
        let diffInMinutes = difference / 60
        
        if diffInMinutes < 60 {
            return "\(String(format: "%.0f", diffInMinutes))m"
        } else if diffInMinutes >= 60 && diffInMinutes < 24 * 60 {
            return "\(String(format: "%.0f", diffInMinutes / 60))h"
        } else if diffInMinutes >= 24 * 60 && diffInMinutes < 7 * 24 * 60 {
            return "\(String(format: "%.0f", diffInMinutes / (60 * 24)))d"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            return formatter.string(from: self.dateValue())
        }
    }
}
