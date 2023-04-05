import SwiftUI

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
  static var defaultValue = CGFloat.zero

  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value += nextValue()
  }
}

struct StockView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var sessionService: SessionService
    @StateObject var vm: StockViewModel
    @State var isNewPostPresented: Bool = false
    @State var isAddAssetPresented: Bool = false
    
    init(symbol: String) {
        _vm = StateObject(wrappedValue: StockViewModel(symbol: symbol, stockService: StockService(symbol: symbol)))
        UIPageControl.appearance().currentPageIndicatorTintColor = .black
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    var body: some View {
        VStack {
            if let company = vm.companyProfile {
                ScrollView(showsIndicators: false) {
                    VStack {
                        header
                            .padding()
                        pickerView
                        switch vm.option {
                        case .home:
                            HomeView(company: company, newsService: NewsService(symbol: company.symbol), isNewViewPresented: $isNewPostPresented)
                        case .financials:
                            FinancialView(company: company)
                        case .valuation:
                            ValuationView(company: company)
                        case .about:
                            AboutView(company: company)
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
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Image(systemName: "plus.circle")
                                .onTapGesture {
                                    isAddAssetPresented.toggle()
                                }
                        }
                    }
                    .background(
                        GeometryReader { proxy in
                            let offset = proxy.frame(in: .named("scroll")).minY
                            Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self, value: offset)
                        })
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                    if value < 20 && vm.showPencil == false {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            vm.showPencil = true
                        }
                    } else if value > -0 && vm.showPencil == true {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            vm.showPencil = false
                        }
                    }
                }
                .overlay(alignment: .bottomTrailing, content: {
                    if vm.option == .home && vm.showPencil && sessionService.session != nil {
                        Image(systemName: "pencil")
                            .font(.title)
                            .foregroundColor(Color.white)
                            .frame(width: 50, height: 50)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .padding()
                            .onTapGesture {
                                vm.isNewPostPresented.toggle()
                            }
                            .offset(x: vm.showPencil ? 0 : 100)
                    }
                })
                .fullScreenCover(isPresented: $isNewPostPresented, content: {
                    NewPostView(symbol: vm.symbol, postService: PostService())
                })
                .sheet(isPresented: $isAddAssetPresented, content: {
                    NewAssetView(symbol: vm.symbol, portfolioService: PortfolioService(), stockService: StockService(symbol: vm.symbol))
                        .presentationDetents([.fraction(0.5)])
                })
                .sync($vm.isNewPostPresented, with:  $isNewPostPresented)
            } else {
                ProgressView()
            }
        }
        .task {
            
            await vm.fetchData()
        }
    }
    
    var header: some View {
        HStack(alignment: .top) {
            if let profile = vm.companyProfile {
                VStack(alignment: .leading) {
                    Text(profile.companyName)
                        .font(.title2)
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
                    PriceView(symbol: profile.symbol, currency: profile.currency)
                }
                Spacer()
                ImageView(imageService: ImageService(url: profile.image))
                    .scaledToFit()
                    .cornerRadius(10)
                    .frame(height: 50)
                    .frame(maxWidth: 100)
            }
        }
    }
    
    var pickerView: some View {
        HStack(spacing: 0) {
            VStack {
                Text("Home")
                    .padding(5)
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
                    .padding(5)
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
                    .padding(5)
                    .fontWeight(vm.option == .valuation ? .semibold : nil)
                    .onTapGesture {
                        vm.option = .valuation
                    }
                Rectangle()
                    .fill(vm.option == .valuation ? Color.black : Color.gray)
                    .frame(height: vm.option == .valuation ? 2 : 1)
            }
            VStack {
                Text("About")
                    .padding(5)
                    .fontWeight(vm.option == .about ? .semibold : nil)
                    .onTapGesture {
                        vm.option = .about
                    }
                Rectangle()
                    .fill(vm.option == .about ? Color.black : Color.gray)
                    .frame(height: vm.option == .about ? 2 : 1)
            }
        }
    }
}

struct StockView_Previews: PreviewProvider {
    static var previews: some View {
        StockView(symbol: "APPL")
    }
}
