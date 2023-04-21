import Foundation

extension Date {
    func dateComponents(timezone: TimeZone, selectedType: ChartOption, calendar: Calendar = .current) -> DateComponents {
        let current = calendar.dateComponents(in: timezone, from: self)
        
        var dc = DateComponents(timeZone: timezone, year: current.year, month: current.month)
        
        
        if selectedType == .oneMonth || selectedType == .oneWeek || selectedType == .oneDay {
            dc.day = current.day
        }
        
        if selectedType == .oneDay {
            dc.hour = current.hour
        }
        
        return dc
    }
}
