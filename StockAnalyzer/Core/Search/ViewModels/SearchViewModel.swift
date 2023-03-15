import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchResult: [Search] = []
    
    var newsSubscription: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addListener()
    }
    
    func addListener() {
        $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] data in
                if data.count > 0 {
                    self?.getData(data: data)
                } else {
                    self?.searchResult = []
                }
            }
            .store(in: &cancellables)
    }
    
    func getData(data: String) {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/search?query=\(data)&exchange=NASDAQ,NYSE&limit=10&apikey=\(ApiKeys.financeApi)") else {return}
        
        newsSubscription = NetworkingManager.download(url: url)
            .decode(type: [Search].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (searchResult) in
                self?.searchResult = searchResult
                self?.newsSubscription?.cancel()
            })
    }
}
