import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchResult: [Search] = []
    
    var newsSubscription: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        //addListener()
    }
    
    func addListener() {
        $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] data in
                self?.getData(data: data)
            }
            .store(in: &cancellables)
    }
    
    func getData(data: String) {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/search?query=\(data)&exchange=NASDAQ,NYSE&limit=10&apikey=d5f365f0f57c273c26a6b52b86a53010") else {return}
        
        newsSubscription = NetworkingManager.download(url: url)
            .decode(type: [Search].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (searchResult) in
                if self?.searchText.count ?? 0 > 0 {
                    self?.searchResult = searchResult
                } else {
                    self?.searchResult = []
                }
                self?.newsSubscription?.cancel()
            })
    }
}
