import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchResult: [Search] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSearchListener()
    }
    
    func addSearchListener() {
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
        
        NetworkingManager.download(url: url)
            .decode(type: [Search].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (searchResult) in
                self?.searchResult = searchResult
            })
            .store(in: &cancellables)
    }
}
