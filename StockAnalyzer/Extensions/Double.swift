import Foundation

extension Double {
    var roundedString: String {
        String(format: "%.2f", self)
    }
    
    var formattedPrice: String {
        var priceAsString: String = String(format: "%.1f", self)
        var prefix = ""
        var result: String
        
        if self < 0 {
            prefix = "-"
            priceAsString = priceAsString.trimmingCharacters(in: CharacterSet(charactersIn: "-"))
        }
        
        let stringParts = priceAsString.split(separator: ".")
        let firstPart = stringParts[0].description
        let secondPart = stringParts[1].description
        
        if firstPart.count % 3 == 0 {
            if firstPart.count > 6 {
                result = "\(firstPart[0...2]).\(firstPart[3...4])"
            } else {
                result = firstPart.count == 6 ? firstPart : "\(firstPart).\(secondPart)"
            }
        } else if firstPart.count % 3 == 1 {
            if firstPart.count >= 7 {
                result = "\(firstPart[0]).\(firstPart[1...2])"
            } else {
                result = "\(firstPart).\(secondPart)"
            }
        } else {
            if firstPart.count >= 8 {
                result = "\(firstPart[0...1]).\(firstPart[2...3])"
            } else {
                result = firstPart.count == 5 ? firstPart : "\(firstPart).\(secondPart)"
            }
        }
        
        if firstPart.count >= 7 && firstPart.count < 10 {
            result.append("M")
        } else if 10 <= firstPart.count && firstPart.count < 13 {
            result.append("B")
        } else if firstPart.count >= 13 {
            result.append("T")
        }
        
        return "\(prefix)$\(result)"
    }
}

    
