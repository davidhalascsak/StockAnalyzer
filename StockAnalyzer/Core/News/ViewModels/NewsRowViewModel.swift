import Foundation

class NewsRowViewModel: ObservableObject {
    let news: News
    
    init(news: News) {
        self.news = news
    }

    func createDate(timestamp: String) -> String {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "US_POSIX")
        formatter.dateFormat = "E, d MMM y HH:mm:ss z"
        

        let date = formatter.date(from: timestamp)
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        
        if let date = date {
            return formatter.string(from: date)
        }
        
        return "unknown date"
    }
}
