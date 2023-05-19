import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var news: [News] = []
    @Published var isLoading: Bool = true
    
    let companyProfile: CompanyProfile
    var newsService: NewsServiceProtocol
    
    init(company companyProfile: CompanyProfile, newsService: NewsServiceProtocol) {
        self.companyProfile = companyProfile
        self.newsService = newsService
    }
    
    func fetchNews() async {
        let fetchedNews = await self.newsService.fetchNews()
        
        if fetchedNews.count > 10 {
            self.news = Array(fetchedNews[0..<10])
        } else {
            
            self.news = fetchedNews
        }
        self.isLoading = false
    }
}
