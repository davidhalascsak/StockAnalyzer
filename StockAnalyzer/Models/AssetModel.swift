import Foundation
import CoreData
import FirebaseFirestoreSwift
import FirebaseFirestore

struct Asset: Hashable, Codable {
    @DocumentID var id: String?
    let symbol: String
    let units: Double
    let averagePrice: Double
    var positionCount: Double
    
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
