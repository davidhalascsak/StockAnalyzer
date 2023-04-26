import Foundation
import CoreData
import FirebaseFirestoreSwift
import FirebaseFirestore

struct Asset: Hashable, Codable {
    let symbol: String
    let units: Double
    let averagePrice: Double
    let investedAmount: Double
    var positionCount: Double
    
    var positions: [Position]?
}

struct Position: Hashable, Codable {
    @DocumentID var id: String?
    let symbol: String
    let date: String
    let units: Double
    let price: Double
    let investedAmount: Double
}
