import Foundation
import Combine

@MainActor
class ValuationViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var ratios: Ratios?
    @Published var marketCap: Int?
    @Published var growthRates: GrowthRates?
    @Published var metrics: Metrics?
    
    @Published var valuationType: ValuationType = .netIncome
    @Published var baseValue: Double?
    @Published var growthRate: Int?
    @Published var discountRate: Int = 8
    @Published var terminalMultiple: Int = 20
    @Published var intrinsicValue: String = ""
    
    var cancellables = Set<AnyCancellable>()
    
    let company: CompanyProfile
    let stockService: StockServiceProtocol
    
    enum ValuationType: CaseIterable, CustomStringConvertible  {
        case netIncome
        case freeCashFlow
        
        var description: String {
            switch self {
            case .netIncome:
                return "Net Income"
            case .freeCashFlow:
                return "Free Cash Flow"
            }
        }
    }
    
    init(company: CompanyProfile, stockService: StockServiceProtocol) {
        self.company = company
        self.stockService = stockService
        
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
    
    func fetchData() async {
        async let fetchRatios = stockService.fetchRatios()
        async let fetchMarketCap = stockService.fetchMarketCap()
        async let fetchGrowthRates = stockService.fetchGrowthRates()
        async let fetchMetrics = stockService.fetchMetrics()
        
        let (ratios, marketCap, growthRates, metrics) = await (fetchRatios, fetchMarketCap, fetchGrowthRates, fetchMetrics)
        
        self.ratios = ratios
        self.marketCap = marketCap
        self.growthRates = growthRates
        self.metrics = metrics
        
        if ratios != nil && marketCap != 0 && growthRates != nil && metrics != nil {
            baseValue = Double(String(format: "%.2f", metrics?.netIncomePerShare ?? 0.0)) ?? 0.0
            growthRate = min(max(Int((growthRates?.netIncomeGrowth ?? 0.0) * 100), 3), 20)
            
            isLoading = false
        }
    }
    
    func resetValuation() {
        if valuationType == .netIncome {
            baseValue = Double(String(format: "%.2f", metrics?.netIncomePerShare ?? 0.0)) ?? 0.0
            growthRate = min(max(Int((growthRates?.netIncomeGrowth ?? 0.0) * 100), 3), 20)
        } else if valuationType == .freeCashFlow {
            baseValue = Double(String(format: "%.2f", metrics?.freeCashFlowPerShare ?? 0.0)) ?? 0.0
            growthRate = min(max(Int((growthRates?.freeCashFlowGrowth ?? 0.0) * 100),3), 20)
        }
    }
    
    func calculateIntrinsicValue() {
        let growthRateAsDecimal = Double(growthRate ?? 0) / 100.0
        let futureValue = Double(terminalMultiple) * (baseValue ?? 0.0) * pow((1.0 + growthRateAsDecimal), 5)
        
        let discountRateAsDecimal = Double(discountRate) / 100.0
        let value = futureValue * pow((1.0 + discountRateAsDecimal), -5)
        
        if value < 0 {
            intrinsicValue = "Invalid Price"
        } else {
            intrinsicValue = String(format: "$%.1f", value)
        }
    }
}
