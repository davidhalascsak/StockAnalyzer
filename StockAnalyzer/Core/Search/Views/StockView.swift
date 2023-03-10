import SwiftUI

struct StockView: View {
    @StateObject var vm: StockViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(symbol: String) {
        _vm = StateObject(wrappedValue: StockViewModel(symbol: symbol))
        UIPageControl.appearance().currentPageIndicatorTintColor = .black
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    var body: some View {
        if let company = vm.companyProfile {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    header
                        .padding()
                    pickerView
                    switch vm.option {
                    case .home:
                        HomeView(company: company)
                    case .financials:
                        FinancialView()
                    case .valuation:
                        ValuationView()
                    }
                }
                .navigationBarBackButtonHidden()
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Image(systemName: "arrowshape.backward")
                            .onTapGesture {
                                dismiss()
                            }
                    }
                }
            }
        } else {
            ProgressView()
        }
    }
    
    var header: some View {
        HStack(alignment: .top) {
            if let profile = vm.companyProfile {
                VStack(alignment: .leading) {
                    Text(profile.companyName)
                        .font(.title)
                        .fontWeight(.bold)
                    Text(profile.sector)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(3)
                        .padding(.horizontal, 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    HStack(alignment: .firstTextBaseline) {
                        Text(String(format: "%.2f", profile.price))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text(profile.currency)
                            .font(.title2)
                    }
                    HStack {
                        Text("\(profile.changes >= 0 ? "+" : "")\(String(format: "%.2f", profile.changes))")
                        Text("(\(vm.decreaseInPercentage(price: profile.price, change: profile.changes))%)")
                    }
                    .font(.headline)
                    .foregroundColor(profile.changes >= 0 ? Color.green : Color.red)
                }
                Spacer()
                LogoView(logo: profile.image)
                    .scaledToFit()
                    .frame(height: 50)
                    .frame(maxWidth: 100)
            }
        }
    }
    
    var pickerView: some View {
        HStack(spacing: 0) {
            VStack {
                Text("Home")
                    .padding()
                    .fontWeight(vm.option == .home ? .semibold : nil)
                    .onTapGesture {
                        vm.option = .home
                    }
                Rectangle()
                    .fill(vm.option == .home ? Color.black : Color.gray)
                    .frame(height: vm.option ==
                        .home ? 2 : 1)
            }
            VStack {
                Text("Financials")
                    .padding()
                    .fontWeight(vm.option == .financials ? .semibold : nil)
                    .onTapGesture {
                        vm.option = .financials
                    }
                Rectangle()
                    .fill(vm.option == .financials
                          ? Color.black : Color.gray)
                    .frame(height: vm.option == .financials ? 2 : 1)
            }
            VStack {
                Text("Valuation")
                    .padding()
                    .fontWeight(vm.option == .valuation ? .semibold : nil)
                    .onTapGesture {
                        vm.option = .valuation
                    }
                Rectangle()
                    .fill(vm.option == .valuation ? Color.black : Color.gray)
                    .frame(height: vm.option == .valuation ? 2 : 1)
            }
        }
    }
}

struct StockView_Previews: PreviewProvider {
    static var previews: some View {
        StockView(symbol: "APPL")
    }
}
