import Foundation

struct News: Codable, Hashable {
    let title: String
    let news_url: String
    let image_url: String
    let date: String
    let source_name: String
    let sentiment: String
    let tickers: [String]
}

struct NewsData: Codable, Hashable {
    let data: [News]
}
