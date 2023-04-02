import Foundation
import Combine

class ValuationViewModel: ObservableObject {
    @Published var ratios: Ratios?
    @Published var marketCap: MarketCap?
    @Published var growthRates: GrowthRates?
    @Published var metrics: Metrics?
    @Published var type: String = "Net Income"
    @Published var baseValue: String = ""
    @Published var growthRate: Int = 0
    @Published var discountRate: Int = 8
    @Published var terminalMultiple: Int = 20
    @Published var intrinsicValue: String = ""
    
    var cancellables = Set<AnyCancellable>()
    
    var isLoaded: Bool {
        return ratios != nil && marketCap != nil && growthRates != nil && metrics != nil
    }
    
    let company: Company
    let options = ["Net Income", "Free Cash Flow"]
    
    init(company: Company) {
        self.company = company
        fetchMarketCap()
        fetchRatios()
        fetchGrowthRates()
        fetchMetrics()
        listenToChanges()
    }
    
    func listenToChanges() {
        Publishers
            .CombineLatest4($baseValue, $growthRate, $discountRate, $terminalMultiple)
            .debounce(for: .seconds(1.0), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.calculateIntrinsicValue()
            }
            .store(in: &cancellables)
    }
    
    func fetchMarketCap() {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/market-capitalization/\(company.symbol)?apikey=\(ApiKeys.financeApi)") else {return}
                
        NetworkingManager.download(url: url)
            .decode(type: [MarketCap].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] enterpriseValue in
                self?.marketCap = enterpriseValue[0]
            }
            .store(in: &cancellables)
    }
    
    func fetchRatios() {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/ratios-ttm/\(company.symbol)?apikey=\(ApiKeys.financeApi)") else {return}
                
        NetworkingManager.download(url: url)
            .decode(type: [Ratios].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] ratios in
                self?.ratios = ratios[0]
            }
            .store(in: &cancellables)
    }
    
    func fetchGrowthRates() {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/financial-growth/\(company.symbol)?limit=1&apikey=\(ApiKeys.financeApi)") else {return}
        NetworkingManager.download(url: url)
            .decode(type: [GrowthRates].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] growthRates in
                self?.growthRates = growthRates[0]
                
                self?.growthRate = min(max(Int((self?.growthRates?.netIncomeGrowth ?? 0.0) * 100),3), 20)
                
            }
            .store(in: &cancellables)
    }
    
    func fetchMetrics() {
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/key-metrics-ttm/\(company.symbol)?limit=1&apikey=\(ApiKeys.financeApi)") else {return}
        NetworkingManager.download(url: url)
            .decode(type: [Metrics].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] metrics in
                self?.metrics = metrics[0]
                self?.baseValue = String(format: "%.2f",self?.metrics?.netIncomePerShareTTM ?? 0.0)
            }
            .store(in: &cancellables)
    }
    
    func formatPrice(price: Int) -> String {
        var priceAsString: String = String(price)
        var prefix = ""
        var result: String
        
        if price < 0 {
            prefix = "-"
            priceAsString = priceAsString.trimmingCharacters(in: CharacterSet(charactersIn: "-"))
        }
        
        if priceAsString.count % 3 == 0 {
            result = "\(priceAsString[0...2]).\(priceAsString[3...5])"
        } else if priceAsString.count % 3 == 1 {
            result = "\(priceAsString[0]).\(priceAsString[1...3])"
        } else {
            result = "\(priceAsString[0...1]).\(priceAsString[2...4])"
        }
        
        if priceAsString.count < 10 {
            result.append("M")
        } else if 10 <= priceAsString.count && priceAsString.count < 13 {
            result.append("B")
        } else {
            result.append("T")
        }
        
        return "\(prefix)\(result)"
    }
    
    func resetValuation() {
        if self.type == "Net Income" {
            self.baseValue = String(format: "%.2f", self.metrics?.netIncomePerShareTTM ?? 0.0)
            self.growthRate = min(max(Int((self.growthRates?.netIncomeGrowth ?? 0.0) * 100), 3), 20)
        } else {
            self.baseValue = String(format: "%.2f", self.metrics?.freeCashFlowPerShareTTM ?? 0.0)
            self.growthRate = min(max(Int((self.growthRates?.freeCashFlowGrowth ?? 0.0) * 100),3), 20)
        }
    }
    
    func calculateIntrinsicValue() {
        let growthRateAsDecimal = Double(self.growthRate) / 100.0
        let futureValue = Double(terminalMultiple) * (((Double(self.baseValue) ?? 0.0) * pow((1.0 + growthRateAsDecimal), 5)))
        
        let discountRateAsDecimal = Double(self.discountRate) / 100.0
        let value = futureValue * pow((1.0 + discountRateAsDecimal), -5)
        
        if value < 0 {
            self.intrinsicValue = "No Value"
        } else {
            self.intrinsicValue = String(format: "$%.1f", value)
        }
    }
}
