import Foundation

extension Int {
    var formattedPrice: String {
        var priceAsString: String = String(self)
        var prefix = ""
        var result: String
        
        if self < 0 {
            prefix = "-"
            priceAsString = priceAsString.trimmingCharacters(in: CharacterSet(charactersIn: "-"))
        }
        
        if priceAsString.count % 3 == 0 {
            if priceAsString.count >= 6 {
                result = "\(priceAsString[0...2]).\(priceAsString[3...4])"
            } else {
                result = priceAsString
            }
        } else if priceAsString.count % 3 == 1 {
            if priceAsString.count >= 7 {
                result = "\(priceAsString[0]).\(priceAsString[1...2])"
            } else {
                result = priceAsString
            }
        } else {
            if priceAsString.count >= 8 {
                result = "\(priceAsString[0...1]).\(priceAsString[2...3])"
            } else {
                result = priceAsString
            }
        }
        
        if priceAsString.count >= 7 && priceAsString.count < 10 {
            result.append("M")
        } else if 10 <= priceAsString.count && priceAsString.count < 13 {
            result.append("B")
        } else if priceAsString.count >= 13 {
            result.append("T")
        }
        
        return "\(prefix)\(result)"
    }
}
