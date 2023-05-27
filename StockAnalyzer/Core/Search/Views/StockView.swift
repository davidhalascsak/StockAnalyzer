import SwiftUI

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
  static var defaultValue = CGFloat.zero

  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value += nextValue()
  }
}

struct StockView: View {
    @Environment(\.dismiss) private var dismiss
    @State var isNewPostPresented: Bool = false
    @State var isAddAssetPresented: Bool = false
    
    @StateObject var viewModel: StockViewModel
    
    init(stockSymbol: String, stockService: StockServiceProtocol, sessionService: SessionServiceProtocol) {
        _viewModel = StateObject(wrappedValue: StockViewModel(stockSymbol: stockSymbol, stockService: stockService, sessionService: sessionService))
        UIPageControl.appearance().currentPageIndicatorTintColor = .black
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
        UITabBar.appearance().isTranslucent = false
    }
    
    var body: some View {
        VStack {
            if let company = viewModel.companyProfile {
                ScrollView(showsIndicators: false) {
                    VStack {
                        headerView
                            .padding()
                        pickerView
                        switch viewModel.option {
                        case .home:
                            HomeView(company: company, newsService: NewsService(stockSymbol: company.stockSymbol), isNewPostPresented: $isNewPostPresented)
                        case .financials:
                            FinancialView(company: company, financeService: FinanceService(stockSymbol: company.stockSymbol))
                        case .valuation:
                            ValuationView(company: company, stockService: StockService(stockSymbol: company.stockSymbol))
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
                                .opacity(viewModel.sessionService.getUserId() != nil ? 1.0 : 0.0)
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
                    if value < 20 && viewModel.showPencil == false {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            viewModel.showPencil = true
                        }
                    } else if value > -0 && viewModel.showPencil == true {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            viewModel.showPencil = false
                        }
                    }
                }
                .overlay(alignment: .bottomTrailing) {
                    if viewModel.option == .home && viewModel.showPencil && viewModel.sessionService.getUserId() != nil {
                        Image(systemName: "pencil")
                            .font(.title)
                            .foregroundColor(Color.white)
                            .frame(width: 50, height: 50)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .padding()
                            .onTapGesture {
                                isNewPostPresented.toggle()
                            }
                            .offset(x: viewModel.showPencil ? 0 : 100)
                    }
                }
                .fullScreenCover(isPresented: $isNewPostPresented) {
                    NewPostView(stockSymbol: viewModel.stockSymbol, postService: PostService())
                }
                .sheet(isPresented: $isAddAssetPresented) {
                    NewAssetView(stockSymbol: viewModel.stockSymbol, portfolioService: PortfolioService(), stockService: StockService(stockSymbol: viewModel.stockSymbol))
                        .presentationDetents([.fraction(0.5)])
                }
            } else {
                ProgressView()
            }
        }
        .task {
            await viewModel.fetchData()
        }
    }
    
    var headerView: some View {
        HStack(alignment: .top) {
            if let profile = viewModel.companyProfile {
                VStack(alignment: .leading) {
                    Text(profile.companyName)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    Text(profile.sector)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(3)
                        .padding(.horizontal, 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    PriceView(stockSymbol: profile.stockSymbol, currency: profile.currency, stockService: StockService(stockSymbol: profile.stockSymbol))
                }
                Spacer()
                ImageView(url: profile.image, defaultImage: "", imageService: ImageService())
                    .scaledToFit()
                    .cornerRadius(10)
                    .shadow(radius: 5)
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
                    .fontWeight(viewModel.option == .home ? .semibold : nil)
                    .onTapGesture {
                        viewModel.option = .home
                    }
                Rectangle()
                    .fill(viewModel.option == .home ? Color.primary : Color.gray)
                    .frame(height: viewModel.option ==
                        .home ? 2 : 1)
            }
            VStack {
                Text("Financials")
                    .padding(5)
                    .fontWeight(viewModel.option == .financials ? .semibold : nil)
                    .onTapGesture {
                        viewModel.option = .financials
                    }
                Rectangle()
                    .fill(viewModel.option == .financials ? Color.primary : Color.gray)
                    .frame(height: viewModel.option == .financials ? 2 : 1)
            }
            VStack {
                Text("Valuation")
                    .padding(5)
                    .fontWeight(viewModel.option == .valuation ? .semibold : nil)
                    .onTapGesture {
                        viewModel.option = .valuation
                    }
                Rectangle()
                    .fill(viewModel.option == .valuation ? Color.primary : Color.gray)
                    .frame(height: viewModel.option == .valuation ? 2 : 1)
            }
            VStack {
                Text("About")
                    .padding(5)
                    .fontWeight(viewModel.option == .about ? .semibold : nil)
                    .onTapGesture {
                        viewModel.option = .about
                    }
                Rectangle()
                    .fill(viewModel.option == .about ? Color.primary : Color.gray)
                    .frame(height: viewModel.option == .about ? 2 : 1)
            }
        }
    }
}

struct StockView_Previews: PreviewProvider {
    static var previews: some View {
        StockView(stockSymbol: "APPL", stockService: MockStockService(stockSymbol: "AAPL"), sessionService: MockSessionService(currentUser: nil))
    }
}
