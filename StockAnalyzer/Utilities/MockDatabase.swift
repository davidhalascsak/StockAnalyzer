import Foundation
import Firebase

class MockDatabase {
    var users: [User] = [
        User(id: "asd123", username: "david", email: "david@gmail.com", country: "Hungary", imageUrl: "https://test_image.com"),
        User(id: "asd321", username: "bob", email: "bob@gmail.com", country: "Hungary", imageUrl: "test_image.com")
    ]
    var authUsers: [TestAuthenticationUser] = [
        TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true),
        TestAuthenticationUser(id: "asd321", email: "bob@domain.com", password: "asd123", isVerified: false)
    ]
    
    var posts: [Post] = [
        Post(id: "22", userRef: "asd123", body: "I like Ike",likeCount: 0, commentCount: 0, stockSymbol: "AAPL", timestamp: Timestamp()),
        Post(id: "19", userRef: "asd321", body: "Good Moring, Vietnam", likeCount: 2, commentCount: 2, stockSymbol: "", timestamp: Timestamp())
    ]
    var likedPosts: [String: [String]] = [
        "asd123": ["19"],
        "asd321": ["19"]
    ]
    
    var comments: [String: [Comment]] = [
        "19": [
            Comment(id: "1", userRef: "asd123", body: "Guten Morgen", timestamp: Timestamp(), likeCount: 1),
            Comment(id: "2", userRef: "asd123", body: "Vietnaaam?", timestamp: Timestamp(), likeCount: 5)
        ]
    ]
    var likedComments: [String: [String]] = ["asd123": ["2"]]
    
    var news: [News] = [
        News(title: "Google, Amazon, Meta, Microsoft, 15 others subject to EU content rules",
             news_url: "https://www.reuters.com/technology/google-amazon-meta-microsoft-15-others-subject-eu-content-rules-2023-04-25/",
             image_url: "https://cdn.snapi.dev/images/v1/l/f/nuqa3mnxevoenobla6da247rue-1852003.jpg",
             date: "Tue, 25 Apr 2023 07:57:45 -0400",
             source_name: "Reuters",
             sentiment: "Negative", tickers: ["GOOGL", "META", "MSFT"]),
        News(title: "Machine learning algorithm sets Amazon stock price for May 2023",
                         news_url: "https://finbold.com/machine-learning-algorithm-sets-amazon-stock-price-for-may-2023/?SNAPI",
                         image_url: "https://cdn.snapi.dev/images/v1/m/a/machine-learning-algorithm-sets-amazon-stock-price-for-may-2023-1851763.jpg",
                         date: "Tue, 25 Apr 2023 06:00:00 -0400",
                         source_name: "Finbold",
                         sentiment: "Neutral", tickers: ["AMZN"]),
        News(title: "AI Boom: 2 Artificial Intelligence Stocks Billionaire Investors Are Buying Hand Over Fist",
                         news_url: "https://www.fool.com/investing/2023/04/25/ai-boom-ai-stocks-billionaire-investors-buying/",
                         image_url: "https://cdn.snapi.dev/images/v1/o/e/urlhttps3a2f2fgfoolcdncom2feditorial2fimages2f7288852fartificial-intelligencejpgopresizew400h400-1851500.jpg",
                         date: "Tue, 25 Apr 2023 06:00:00 -0400",
                         source_name: "The Motley Fool",
                         sentiment: "Positive", tickers: ["AMZN"])
    ]
    
    var searchResult: [SearchResult] = [
        SearchResult(stockSymbol: "AAPL", name: "Apple", exchangeShortName: "NASDAQ"),
        SearchResult(stockSymbol: "MSFT", name: "Microsoft", exchangeShortName: "NASDAQ"),
        SearchResult(stockSymbol: "DIS", name: "Disney", exchangeShortName: "NYSE"),
        SearchResult(stockSymbol: "MA", name: "Mastercard", exchangeShortName: "NYSE")
    ]
    
    var assets: [Asset] = [
        Asset(stockSymbol: "AAPL", units: 2.0, averagePrice: 132.5, positionCount: 1),
        Asset(stockSymbol: "MSFT", units: 3.0, averagePrice: 230.0, positionCount: 1)
    ]
    
    var positions: [String: [Position]] = [
        "AAPL": [Position(id: "1", date: "2023-02-02", units: 1, price: 132.5),
        Position(date: "2023-01-02", units: 1, price: 132.5)],
        "MSFT": [Position(id: "2", date: "2020-02-02", units: 3.0, price: 230.0)]
    ]
    
    var imageUrls: [String: Data] = [
        "https://test_image.com": UIImage(named: "default_avatar")?.jpegData(compressionQuality: 0.5) ?? Data(),
    ]
    
    var fiveMinData: [String : [HistoricalPrice]] = [
        "AAPL": [
            HistoricalPrice(date: "2020-03-02 10:35:00", open: 280, close: 280),
            HistoricalPrice(date: "2020-03-02 10:30:00", open: 280, close: 280),
            HistoricalPrice(date: "2020-03-02 10:25:00", open: 280, close: 280),
            HistoricalPrice(date: "2020-03-02 10:20:00", open: 280, close: 280),
            HistoricalPrice(date: "2020-03-02 10:15:00", open: 278, close: 278),
            HistoricalPrice(date: "2020-03-02 10:10:00", open: 280, close: 280),
            HistoricalPrice(date: "2020-03-02 10:05:00", open: 280, close: 280),
            HistoricalPrice(date: "2020-03-02 10:00:00", open: 280, close: 280),
            HistoricalPrice(date: "2020-03-02 09:55:00", open: 280, close: 280),
            HistoricalPrice(date: "2020-03-02 09:50:00", open: 280, close: 280),
            HistoricalPrice(date: "2020-03-02 09:45:00", open: 280, close: 280),
            HistoricalPrice(date: "2020-03-02 09:40:00", open: 281, close: 281),
            HistoricalPrice(date: "2020-03-02 09:35:00", open: 280, close: 280),
            HistoricalPrice(date: "2020-03-02 09:30:00", open: 280, close: 280),
        ]
    ]
    
    var hourlyData: [String : [HistoricalPrice]] = [
        "AAPL": [
            HistoricalPrice(date: "2023-04-27 16:00:00", open: 280, close: 280),
            HistoricalPrice(date: "2023-04-27 15:00:00", open: 280, close: 280),
            HistoricalPrice(date: "2023-04-27 14:00:00", open: 280, close: 280),
            HistoricalPrice(date: "2023-04-27 13:00:00", open: 280, close: 280),
            HistoricalPrice(date: "2023-04-27 12:00:00", open: 275, close: 275),
            HistoricalPrice(date: "2023-04-27 11:00:00", open: 280, close: 280),
            HistoricalPrice(date: "2023-04-27 10:00:00", open: 280, close: 280),
            HistoricalPrice(date: "2023-04-26 16:00:00", open: 300, close: 300),
            HistoricalPrice(date: "2023-04-26 15:00:00", open: 280, close: 280),
            HistoricalPrice(date: "2023-04-26 14:00:00", open: 280, close: 280),
            HistoricalPrice(date: "2023-04-26 13:00:00", open: 280, close: 280),
            HistoricalPrice(date: "2023-04-26 12:00:00", open: 290, close: 290),
            HistoricalPrice(date: "2023-04-26 11:00:00", open: 285, close: 285),
            HistoricalPrice(date: "2023-04-26 10:00:00", open: 280, close: 280),
        ]
    ]
    
    var dailyData: [String : [HistoricalPrice]] = [
        "AAPL": [
            HistoricalPrice(date: "2020-03-20", open: 285, close: 285),
            HistoricalPrice(date: "2020-03-19", open: 280, close: 280),
            HistoricalPrice(date: "2020-03-18", open: 280, close: 280),
            HistoricalPrice(date: "2020-03-17", open: 280, close: 280),
            HistoricalPrice(date: "2020-03-16", open: 280, close: 280),
            HistoricalPrice(date: "2020-03-13", open: 275, close: 275),
            HistoricalPrice(date: "2020-03-12", open: 280, close: 280),
            HistoricalPrice(date: "2020-03-11", open: 280, close: 280),
            HistoricalPrice(date: "2020-03-10", open: 300, close: 300),
            HistoricalPrice(date: "2020-03-09", open: 280, close: 280),
            HistoricalPrice(date: "2020-03-06", open: 280, close: 280),
            HistoricalPrice(date: "2020-03-05", open: 280, close: 280),
            HistoricalPrice(date: "2020-03-04", open: 290, close: 290),
            HistoricalPrice(date: "2020-03-03", open: 285, close: 285),
            HistoricalPrice(date: "2020-03-02", open: 280, close: 280),
        ]
    ]
    
    var incomeStatement: [IncomeStatement] = [
        IncomeStatement(date: "2022-09-24", reportedCurrency: "USD", revenue: 394328000000, grossProfit: 170782000000, operatingIncome: 119437000000, incomeBeforeTax: 119103000000, incomeTaxExpense: 19300000000, netIncome: 99803000000, shareOutstanding: 16215963000),
            IncomeStatement(date: "2021-09-25", reportedCurrency: "USD", revenue: 365817000000, grossProfit: 152836000000, operatingIncome: 108949000000, incomeBeforeTax: 109207000000, incomeTaxExpense: 14527000000, netIncome: 94680000000, shareOutstanding: 16701272000),
            IncomeStatement(date: "2020-09-26", reportedCurrency: "USD", revenue: 274515000000, grossProfit: 104956000000, operatingIncome: 66288000000, incomeBeforeTax: 67091000000, incomeTaxExpense: 9680000000, netIncome: 57411000000, shareOutstanding: 17352119000),
            IncomeStatement(date: "2019-09-28", reportedCurrency: "USD", revenue: 260174000000, grossProfit: 98392000000, operatingIncome: 63930000000, incomeBeforeTax: 65737000000, incomeTaxExpense: 10481000000, netIncome: 55256000000, shareOutstanding: 18471336000),
            IncomeStatement(date: "2018-09-29", reportedCurrency: "USD", revenue: 265595000000, grossProfit: 101839000000, operatingIncome: 70898000000, incomeBeforeTax: 72903000000, incomeTaxExpense: 13372000000, netIncome: 59531000000, shareOutstanding: 19821508000)
    ]
    
    var balanceSheet: [BalanceSheet] = [
        BalanceSheet(date: "2022-09-24", reportedCurrency: "USD", totalCurrentAssets: 135405000000, totalNonCurrentAssets: 217350000000, shortTermDebt: 21110000000, totalCurrentLiabilities: 153982000000, longTermDebt: 98959000000,  totalNonCurrentLiabilities: 148101000000, netDebt: 96423000000),
        BalanceSheet(date: "2021-09-25", reportedCurrency: "USD", totalCurrentAssets: 134836000000, totalNonCurrentAssets: 216166000000, shortTermDebt: 15613000000, totalCurrentLiabilities: 125481000000, longTermDebt: 109106000000,  totalNonCurrentLiabilities: 162431000000, netDebt: 89779000000),
        BalanceSheet(date: "2020-09-26", reportedCurrency: "USD", totalCurrentAssets: 143713000000, totalNonCurrentAssets: 180175000000, shortTermDebt: 13769000000, totalCurrentLiabilities: 105392000000, longTermDebt: 98667000000, totalNonCurrentLiabilities: 153157000000, netDebt: 74420000000),
          BalanceSheet(date: "2019-09-28", reportedCurrency: "USD", totalCurrentAssets: 162819000000, totalNonCurrentAssets: 175697000000, shortTermDebt: 16240000000, totalCurrentLiabilities: 105718000000, longTermDebt: 91807000000, totalNonCurrentLiabilities: 142310000000, netDebt: 59203000000),
         BalanceSheet(date: "2018-09-29", reportedCurrency: "USD", totalCurrentAssets: 234386000000, totalNonCurrentAssets: 234386000000, shortTermDebt: 20748000000, totalCurrentLiabilities: 116866000000, longTermDebt: 93735000000, totalNonCurrentLiabilities: 141712000000, netDebt: 88570000000)
    ]
    
    
    
    var cashFlowStatement: [CashFlowStatement] = [
        CashFlowStatement(date: "2022-09-24", reportedCurrency: "USD", operatingCashFlow: 122151000000, capitalExpenditure: -10708000000, freeCashFlow: 111443000000),
        CashFlowStatement(date: "2021-09-25", reportedCurrency: "USD", operatingCashFlow: 104038000000, capitalExpenditure: -11085000000, freeCashFlow: 92953000000),
        CashFlowStatement(date: "2020-09-26", reportedCurrency: "USD", operatingCashFlow: 80674000000, capitalExpenditure: -7309000000, freeCashFlow: 3365000000),
        CashFlowStatement(date: "2019-09-28", reportedCurrency: "USD", operatingCashFlow: 69391000000, capitalExpenditure: -10495000000, freeCashFlow: 58896000000),
        CashFlowStatement(date: "2018-09-29", reportedCurrency: "USD", operatingCashFlow: 77434000000, capitalExpenditure: -13313000000, freeCashFlow: 64121000000)
    ]
    
}
