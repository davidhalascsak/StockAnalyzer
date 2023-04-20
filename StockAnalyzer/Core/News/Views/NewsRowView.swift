import SwiftUI

struct NewsRowView: View {
    @StateObject var vm: NewsRowViewModel
    
    init(news: News) {
        _vm = StateObject(wrappedValue: NewsRowViewModel(news: news))
    }
    
    var body: some View {
        Link(destination: URL(string: vm.news.news_url)!) {
            HStack {
                imageView
                VStack(alignment: .leading) {
                    Text(vm.news.title)
                        .multilineTextAlignment(.leading)
                        .fontWeight(.semibold)
                    HStack {
                        Text(vm.news.source_name)
                            .multilineTextAlignment(.leading)
                        Text("•")
                        Text(vm.createDate(timestamp: vm.news.date))
                    }
                }
            }
            .foregroundColor(Color.black)
            .frame(height: 100)
        }
    }
    
    var imageView: some View {
        ImageView(url: vm.news.image_url, defaultImage: "", imageService: ImageService())
            .frame(width: 100, height: 100)
            .cornerRadius(20)
    }
}

struct NewsRowView_Previews: PreviewProvider {
    static let news: News = News(title: "Amazon: Long-Term Value Unaffected By Short-Term Headwinds", news_url: "https://seekingalpha.com/article/4585751-amazon-long-term-value-unaffected-by-short-term-headwinds", image_url: "https://cdn.snapi.dev/images/v1/7/z/image-1359131145-1788551.jpg", date: "Wed, 08 Mar 2023 17:44:12 -0500", source_name: "Seeking Alpha", sentiment: "Positive")
    static var previews: some View {
        NewsRowView(news: news)
    }
}
