import Foundation
import CoreData
import FirebaseFirestoreSwift
import FirebaseFirestore

struct Asset: Hashable, Codable {
    @DocumentID var id: String?
    let stockSymbol: String
    let units: Double
    let averagePrice: Double
    var positionCount: Int
    
    var positions: [Position]?
    var investedAmount: Double {
        return averagePrice * units
    }
}

struct Position: Hashable, Codable {
    @DocumentID var id: String?
    let date: String
    let units: Double
    let price: Double
    
    var investedAmount: Double {
        return price * units
    }
}
