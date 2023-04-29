import Foundation
import Firebase

class MockDatabase {
    var users: [User] = [
        User(id: "asd123", username: "david", email: "david@gmail.com", location: "Hungary", imageUrl: "https://test_image.com"),
        User(id: "asd321", username: "bob", email: "bob@gmail.com", location: "Hungary", imageUrl: "test_image.com")
    ]
    var authUsers: [AuthUser] = [
        AuthUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true),
        AuthUser(id: "asd321", email: "bob@domain.com", password: "asd123", isVerified: false)
    ]
    
    var posts: [Post] = [
        Post(id: "22", userRef: "asd123", body: "I like Ike", timestamp: Timestamp(),likes: 0, comments: 0, symbol: "AAPL"),
        Post(id: "19", userRef: "asd321", body: "Good Moring, Vietnam", timestamp: Timestamp(), likes: 2, comments: 2, symbol: "")
    ]
    var likedPosts: [String: [String]] = [
        "asd123": ["19"],
        "asd321": ["19"]
    ]
    
    var comments: [String: [Comment]] = [
        "19": [
            Comment(id: "1", userRef: "asd123", body: "Guten Morgen", timestamp: Timestamp(), likes: 1),
            Comment(id: "2", userRef: "asd123", body: "Vietnaaam?", timestamp: Timestamp(), likes: 5)
        ]
    ]
    var likedComments: [String: [String]] = ["asd123": ["2"]]
    
    var news: [News] = [
        News(title: "Google, Amazon, Meta, Microsoft, 15 others subject to EU content rules",
             news_url: "https://www.reuters.com/technology/google-amazon-meta-microsoft-15-others-subject-eu-content-rules-2023-04-25/",
             image_url: "https://cdn.snapi.dev/images/v1/l/f/nuqa3mnxevoenobla6da247rue-1852003.jpg",
             date: "Tue, 25 Apr 2023 07:57:45 -0400",
             source_name: "Reuters",
             sentiment: "Negative", tickers: ["Google", "Meta", "Microsoft"]),
        News(title: "Machine learning algorithm sets Amazon stock price for May 2023",
                         news_url: "https://finbold.com/machine-learning-algorithm-sets-amazon-stock-price-for-may-2023/?SNAPI",
                         image_url: "https://cdn.snapi.dev/images/v1/m/a/machine-learning-algorithm-sets-amazon-stock-price-for-may-2023-1851763.jpg",
                         date: "Tue, 25 Apr 2023 06:00:00 -0400",
                         source_name: "Finbold",
                         sentiment: "Neutral", tickers: ["Amazon"]),
        News(title: "AI Boom: 2 Artificial Intelligence Stocks Billionaire Investors Are Buying Hand Over Fist",
                         news_url: "https://www.fool.com/investing/2023/04/25/ai-boom-ai-stocks-billionaire-investors-buying/",
                         image_url: "https://cdn.snapi.dev/images/v1/o/e/urlhttps3a2f2fgfoolcdncom2feditorial2fimages2f7288852fartificial-intelligencejpgopresizew400h400-1851500.jpg",
                         date: "Tue, 25 Apr 2023 06:00:00 -0400",
                         source_name: "The Motley Fool",
                         sentiment: "Positive", tickers: ["Amazon"])
    ]
    
    var searchResult: [Search] = [
        Search(symbol: "AAPL", name: "Apple", currency: "USD", stockExchange: "NASDAQ", exchangeShortName: "NASDAQ"),
        Search(symbol: "MSFT", name: "Microsoft", currency: "USD", stockExchange: "NASDAQ", exchangeShortName: "NASDAQ"),
        Search(symbol: "DIS", name: "Disney", currency: "USD", stockExchange: "NYSE", exchangeShortName: "NYSE"),
        Search(symbol: "MA", name: "Mastercard", currency: "USD", stockExchange: "NYSE", exchangeShortName: "NYSE")
    ]
    
    var assets: [Asset] = [
        Asset(symbol: "AAPL", units: 2.0, averagePrice: 132.5, investedAmount: 265.0, positionCount: 1),
        Asset(symbol: "MSFT", units: 3.0, averagePrice: 230.0, investedAmount: 690.0, positionCount: 1)
    ]
    
    var positions: [Position] = [
        Position(symbol: "AAPL", date: "2023-02-02", units: 1, price: 132.5, investedAmount: 132.5),
        Position(symbol: "AAPL", date: "2023-01-02", units: 1, price: 132.5, investedAmount: 132.5),
        Position(symbol: "MSFT", date: "2020-02-02", units: 3.0, price: 230.0, investedAmount: 690.0)
    ]
    
    var imageUrls: [String: Data] = [
        "https://test_image.com": UIImage(named: "default_avatar")?.jpegData(compressionQuality: 0.5) ?? Data(),
    ]
    
    var FiveMinData: [String : [ChartData]] = [
        "AAPL": [
            ChartData(date: "2020-03-02 10:35:00", open: 280, close: 280),
            ChartData(date: "2020-03-02 10:30:00", open: 280, close: 280),
            ChartData(date: "2020-03-02 10:25:00", open: 280, close: 280),
            ChartData(date: "2020-03-02 10:20:00", open: 280, close: 280),
            ChartData(date: "2020-03-02 10:15:00", open: 278, close: 278),
            ChartData(date: "2020-03-02 10:10:00", open: 280, close: 280),
            ChartData(date: "2020-03-02 10:05:00", open: 280, close: 280),
            ChartData(date: "2020-03-02 10:00:00", open: 280, close: 280),
            ChartData(date: "2020-03-02 09:55:00", open: 280, close: 280),
            ChartData(date: "2020-03-02 09:50:00", open: 280, close: 280),
            ChartData(date: "2020-03-02 09:45:00", open: 280, close: 280),
            ChartData(date: "2020-03-02 09:40:00", open: 281, close: 281),
            ChartData(date: "2020-03-02 09:35:00", open: 280, close: 280),
            ChartData(date: "2020-03-02 09:30:00", open: 280, close: 280),
        ]
    ]
    
    var OneHourData: [String : [ChartData]] = [
        "AAPL": [
            ChartData(date: "2023-04-27 16:00:00", open: 280, close: 280),
            ChartData(date: "2023-04-27 15:00:00", open: 280, close: 280),
            ChartData(date: "2023-04-27 14:00:00", open: 280, close: 280),
            ChartData(date: "2023-04-27 13:00:00", open: 280, close: 280),
            ChartData(date: "2023-04-27 12:00:00", open: 275, close: 275),
            ChartData(date: "2023-04-27 11:00:00", open: 280, close: 280),
            ChartData(date: "2023-04-27 10:00:00", open: 280, close: 280),
            ChartData(date: "2023-04-26 16:00:00", open: 300, close: 300),
            ChartData(date: "2023-04-26 15:00:00", open: 280, close: 280),
            ChartData(date: "2023-04-26 14:00:00", open: 280, close: 280),
            ChartData(date: "2023-04-26 13:00:00", open: 280, close: 280),
            ChartData(date: "2023-04-26 12:00:00", open: 290, close: 290),
            ChartData(date: "2023-04-26 11:00:00", open: 285, close: 285),
            ChartData(date: "2023-04-26 10:00:00", open: 280, close: 280),
        ]
    ]
    
    var DailyData: [String : [ChartData]] = [
        "AAPL": [
            ChartData(date: "2020-03-20", open: 285, close: 285),
            ChartData(date: "2020-03-19", open: 280, close: 280),
            ChartData(date: "2020-03-18", open: 280, close: 280),
            ChartData(date: "2020-03-17", open: 280, close: 280),
            ChartData(date: "2020-03-16", open: 280, close: 280),
            ChartData(date: "2020-03-13", open: 275, close: 275),
            ChartData(date: "2020-03-12", open: 280, close: 280),
            ChartData(date: "2020-03-11", open: 280, close: 280),
            ChartData(date: "2020-03-10", open: 300, close: 300),
            ChartData(date: "2020-03-09", open: 280, close: 280),
            ChartData(date: "2020-03-06", open: 280, close: 280),
            ChartData(date: "2020-03-05", open: 280, close: 280),
            ChartData(date: "2020-03-04", open: 290, close: 290),
            ChartData(date: "2020-03-03", open: 285, close: 285),
            ChartData(date: "2020-03-02", open: 280, close: 280),
        ]
    ]
}
