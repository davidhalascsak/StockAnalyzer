import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var news: [News] = []
    @Published var isDownloadingNews: Bool = false
    
    let companyProfile: Company
    let newsService: NewsService
    
    private var cancellables = Set<AnyCancellable>()
    
    init(company companyProfile: Company) {
        self.companyProfile = companyProfile
        self.newsService = NewsService(symbol: companyProfile.symbol)
        self.isDownloadingNews = true
        
        self.addSubscribers()
    }
    
    func addSubscribers() {
        self.newsService.$allNews
            .sink { [weak self] (news) in
                if news.count > 10 {
                    self?.news = Array(news[0..<10])
                } else {
                    self?.news = news
                }
                self?.isDownloadingNews = false
            }
            .store(in: &cancellables)
    }
}
