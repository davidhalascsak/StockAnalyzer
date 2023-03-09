import SwiftUI
import FirebaseCore
import FirebaseAuth

struct NewsView: View {
    @State var vm = NewsViewModel()
    @State var isSettingsPresented: Bool = false
    var body: some View {
        VStack {
            newsHeader
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    Divider().id("top")
                    LazyVStack(alignment: .leading) {
                        ForEach(vm.news, id: \.self) { new in
                            if let link = URL(string: new.link) {
                                HStack {
                                    Link(destination: link) {
                                        Text(new.title)
                                            .foregroundColor(Color.black)
                                            .font(.headline)
                                            .multilineTextAlignment(.leading)
                                            .padding(.horizontal)
                                            .padding(.vertical, 5)
                                    }
                                    Spacer()
                                }
                                HStack {
                                    Text(NewsViewModel.createDate(timestamp: new.pubDate))
                                    Text("•")
                                    Text(new.source!)
                                }
                                .font(.subheadline)
                                .padding(.horizontal)
                                Divider()
                            }
                        }
                    }
                    .onChange(of: vm.shouldScroll) { _ in
                        withAnimation(.spring()) {
                            print("changed - \(vm.shouldScroll)")
                            proxy.scrollTo("top")
                        }
                    }
                }
                .fullScreenCover(isPresented: $isSettingsPresented, content: {
                    SettingsView()
                })
            }
            
        }
        
    }
    
    var newsHeader: some View {
        HStack() {
            Image(systemName: "arrow.triangle.2.circlepath")
                .font(.title2)
                .onTapGesture {
                    withAnimation {
                        vm.reloadData()
                        vm.shouldScroll.toggle()
                    }
                }
                .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)
            Spacer()
            Text("Feed")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color.blue)
            Spacer()
            Image(systemName: "person.crop.circle")
                .font(.title2)
                .onTapGesture {
                    self.isSettingsPresented.toggle()
                }
        }
        .padding(.horizontal)
    }
}

struct WatchlistView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}
