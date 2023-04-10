import Foundation
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var news: [News] = []
    @Published var isDownloadingNews: Bool = false
    
    let companyProfile: Company
    var newsService: NewsServiceProtocol
    
    init(company companyProfile: Company, newsService: NewsServiceProtocol) {
        self.companyProfile = companyProfile
        self.newsService = newsService
    }
    
    func fetchNews() async {
        let fetchedNews = await self.newsService.fetchData()
        
        if fetchedNews.count > 10 {
            self.news = Array(fetchedNews[0..<10])
        } else {
            
            self.news = fetchedNews
        }
        self.isDownloadingNews = false
    }
}
