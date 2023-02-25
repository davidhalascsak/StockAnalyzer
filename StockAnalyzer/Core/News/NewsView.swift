import SwiftUI
import FirebaseCore
import FirebaseAuth

struct NewsView: View {
    @State var vm = NewsViewModel()
    @State var isSettingsPresented: Bool = false
    var body: some View {
        VStack {
            newsHeader
            ScrollView {
                ForEach(vm.news, id: \.self) { new in
                    if let link = URL(string: new.link) {
                        VStack(alignment: .leading) {
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
                                Text(new.source)
                            }
                            .font(.subheadline)
                            .padding(.horizontal)
                        }
                        Divider()
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $isSettingsPresented, content: {
            SettingsView()
        })
    }
    
    var newsHeader: some View {
        HStack() {
            Image(systemName: "arrow.triangle.2.circlepath")
                .font(.title2)
                .onTapGesture {
                    withAnimation(.linear(duration: 2.0)) {
                        vm.reloadData()
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
