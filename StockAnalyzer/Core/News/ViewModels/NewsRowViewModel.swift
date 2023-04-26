import Foundation

class NewsRowViewModel: ObservableObject {
    let news: News
    
    init(news: News) {
        self.news = news
    }

    func formatDate() -> String {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "US_POSIX")
        formatter.dateFormat = "E, d MMM y HH:mm:ss z"
        

        let newDate = formatter.date(from: news.date)
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        
        if let newDate = newDate {
            return formatter.string(from: newDate)
        }
        
        return "unknown date"
    }
}
