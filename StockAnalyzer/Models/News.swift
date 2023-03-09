import Foundation

struct News: Codable, Hashable {
    let title: String
    let link: String
    let pubDate: String
    let source: String?
    let guid: String
}

struct CompanyNews: Codable, Hashable {
    let item: [News]
}
