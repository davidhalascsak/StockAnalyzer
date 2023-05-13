import SwiftUI

struct NewsRowView: View {
    let news: News
    
    var body: some View {
        HStack {
            ImageView(url: news.image_url, defaultImage: "", imageService: ImageService())
                .frame(width: 100, height: 100)
                .cornerRadius(20)
            VStack(alignment: .leading) {
                Text(news.title)
                    .multilineTextAlignment(.leading)
                    .fontWeight(.semibold)
                HStack {
                    Text(news.source_name)
                        .multilineTextAlignment(.leading)
                    Text("•")
                    Text(news.date.formatDateString(from: "E, d MMM y HH:mm:ss z", to: "yyyy-MM-dd"))
                }
            }
        }
        .foregroundColor(Color.primary)
        .frame(height: 100)
    }
}

struct NewsRowView_Previews: PreviewProvider {
    static let news: News = News(title: "Amazon: Long-Term Value Unaffected By Short-Term Headwinds", news_url: "https://seekingalpha.com/article/4585751-amazon-long-term-value-unaffected-by-short-term-headwinds", image_url: "https://cdn.snapi.dev/images/v1/7/z/image-1359131145-1788551.jpg", date: "Wed, 08 Mar 2023 17:44:12 -0500", source_name: "Seeking Alpha", sentiment: "Positive", tickers: ["Amazon"])
    static var previews: some View {
        NewsRowView(news: news)
    }
}
