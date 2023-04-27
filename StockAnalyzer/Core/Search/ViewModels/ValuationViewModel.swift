import Foundation
import Combine

@MainActor
class ValuationViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var ratios: Ratios?
    @Published var marketCap: MarketCap?
    @Published var growthRates: GrowthRates?
    @Published var metrics: Metrics?
    
    @Published var valuationType: String = "Net Income"
    @Published var baseValue: Double = 0
    @Published var growthRate: Int = 0
    @Published var discountRate: Int = 8
    @Published var terminalMultiple: Int = 20
    @Published var intrinsicValue: String = ""
    
    var cancellables = Set<AnyCancellable>()
    
    let company: Company
    let stockService: StockServiceProtocol
    let options = ["Net Income", "Free Cash Flow"]
    
    init(company: Company, stockService: StockServiceProtocol) {
        self.company = company
        self.stockService = stockService
        
        listenToChanges()
    }
    
    func listenToChanges() {
        Publishers
            .CombineLatest4($baseValue, $growthRate, $discountRate, $terminalMultiple)
            .debounce(for: .seconds(1.0), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                print("hello")
                self?.calculateIntrinsicValue()
            }
            .store(in: &cancellables)
    }
    
    func fetchData() async {
        async let fetchRatios = self.stockService.fetchRatios()
        async let fetchMarketCap = self.stockService.fetchMarketCap()
        async let fetchGrowthRates = self.stockService.fetchGrowthRates()
        async let fetchMetrics = self.stockService.fetchMetrics()
        
        let (ratios, marketCap, growthRates, metrics) = await (fetchRatios, fetchMarketCap, fetchGrowthRates, fetchMetrics)
        
        self.ratios = ratios
        self.marketCap = marketCap
        self.growthRates = growthRates
        self.metrics = metrics
        
        self.baseValue = Double(String(format: "%.2f", metrics?.netIncomePerShareTTM ?? 0.0)) ?? 0.0
        self.growthRate = min(max(Int((growthRates?.netIncomeGrowth ?? 0.0) * 100), 3), 20)
        
        self.isLoading = false
    }
    
    func resetValuation() {
        if self.valuationType == "Net Income" {
            self.baseValue = Double(String(format: "%.2f", metrics?.netIncomePerShareTTM ?? 0.0)) ?? 0.0
            self.growthRate = min(max(Int((growthRates?.netIncomeGrowth ?? 0.0) * 100), 3), 20)
        } else if self.valuationType == "Free Cash Flow" {
            self.baseValue = Double(String(format: "%.2f", metrics?.freeCashFlowPerShareTTM ?? 0.0)) ?? 0.0
            self.growthRate = min(max(Int((growthRates?.freeCashFlowGrowth ?? 0.0) * 100),3), 20)
        }
    }
    
    func calculateIntrinsicValue() {
        let growthRateAsDecimal = Double(growthRate) / 100.0
        let futureValue = Double(terminalMultiple) * baseValue * pow((1.0 + growthRateAsDecimal), 5)
        
        let discountRateAsDecimal = Double(discountRate) / 100.0
        let value = futureValue * pow((1.0 + discountRateAsDecimal), -5)
        
        if value < 0 {
            self.intrinsicValue = "Invalid Price"
        } else {
            self.intrinsicValue = String(format: "$%.1f", value)
        }
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
}
