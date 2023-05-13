import Foundation

extension String {
    subscript(offset: Int) -> Character { self[index(startIndex, offsetBy: offset)] }
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }

    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
    
    func formatDateString(from: String, to: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "US_POSIX")
        formatter.dateFormat = from
        

        let newDate = formatter.date(from: self)
        
        formatter.dateFormat = to
        
        
        if let newDate = newDate {
            return formatter.string(from: newDate)
        }
        
        return "unknown date"
    }
}
