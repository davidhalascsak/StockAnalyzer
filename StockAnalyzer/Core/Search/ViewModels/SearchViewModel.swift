import Foundation
import Combine

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchResult: [Search] = []
    @Published var searchTask: Task<(), Error>?
    
    let searchService: SearchServiceProtocol
    
    init(searchService: SearchServiceProtocol) {
        self.searchService = searchService
    }
    
    func fetchData() async {
        self.searchResult = await self.searchService.fetchData(text: self.searchText)
    }
}
