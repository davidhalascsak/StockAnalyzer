import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct PostView: View {
    @State var post: Post
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Button("Protocol") {
                    post.likes = 1
                }
                
                HStack() {
                    Rectangle()
                        .frame(width: 40, height: 40)
                        .cornerRadius(10)
                    VStack(alignment: .leading) {
                        Text(post.user?.username ?? "")
                            .foregroundColor(.blue)
                            .font(.headline)
                        Text(post.user?.location ?? "")
                            .font(.subheadline)
                    }
                }
                
                Text(post.body)
                    .multilineTextAlignment(.leading)
                    .padding(.vertical)
                HStack {
                    Text("\(Image(systemName: "hand.thumbsup")) \(post.likes)")
                    NavigationLink {
                        PostDetailView(post: post)
                    } label: {
                        HStack {
                            Image(systemName: "message")
                                .foregroundColor(Color.black)
                        }
                    }
                    Text("\(post.commentsRef.count)")
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        }
    }
}
/*
 struct PostView_Previews: PreviewProvider {
 
  static var previews: some View {
      let user = User(username: "istengyermeke", email: "david.halascsak@gmail.com", location: "Hungary")
      let post = Post(userRef: nil, body: "Buy Tesla", likes: 5, user: user)
      
      PostView(post: post)
  
  
  }
  
 }
 */
