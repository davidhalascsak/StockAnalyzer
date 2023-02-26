import Foundation
import Combine


class StockViewModel: ObservableObject {
    @Published var companyProfile: Company?
    @Published var isLoading: Bool = false
    
    let symbol: String
    //let stockService: StockService
    
    var cancellables = Set<AnyCancellable>()
    
    init(symbol: String) {
        self.symbol = symbol
        //self.stockService = StockService(symbol: symbol)
        //self.isLoading = true
        //addSubscribers()
    }
    
    /*
    func addSubscribers() {
        self.stockService.$companyInformation
            .sink { [weak self] (companyProfile) in
                self?.companyProfile = companyProfile ?? nil
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
     */
}
