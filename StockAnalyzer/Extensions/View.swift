import Foundation
import SwiftUI
import Firebase

extension View {
    func sync(_ published: Binding<Bool>, with binding: Binding<Bool>) -> some View {
        self
            .onChange(of: published.wrappedValue) { published in
                binding.wrappedValue = published
            }
            .onChange(of: binding.wrappedValue) { binding in
                published.wrappedValue = binding
            }
    }
    
    func sync(_ published: Binding<ChartOption>, with binding: Binding<ChartOption>) -> some View {
        self
            .onChange(of: published.wrappedValue) { published in
                binding.wrappedValue = published
            }
            .onChange(of: binding.wrappedValue) { binding in
                published.wrappedValue = binding
            }
    }
    
    func toDate(stamp: Timestamp) -> String {
        let difference = Date().timeIntervalSince(stamp.dateValue())
        let diffInMinutes = difference / 60
        
        if diffInMinutes < 60 {
            return "\(String(format: "%.0f", diffInMinutes))m"
        } else if diffInMinutes >= 60 && diffInMinutes < 24 * 60 {
            return "\(String(format: "%.0f", diffInMinutes / 60))h"
        } else if diffInMinutes >= 24 * 60 && diffInMinutes < 7 * 24 * 60 {
            return "\(String(format: "%.0f", diffInMinutes / (60 * 24)))d"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            
            return formatter.string(from: stamp.dateValue())
        }
    }
}

