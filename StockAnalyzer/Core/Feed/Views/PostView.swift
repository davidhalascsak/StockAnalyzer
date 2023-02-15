import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct PostView: View {
    var post: Post
    var currentEmail = Auth.auth().currentUser?.email
    let userService = UserService()
    let postService = PostService()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
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
                    Image(systemName: "hand.thumbsup")
                        .onTapGesture {
                            userService.fetchUserReference(email: currentEmail ?? "") { id in
                                if let id = id {
                                    postService.updateLikes(post: self.post, userId: id) {
                                    }
                                }
                                
                            }
                        }
                    Text("\(post.likesRef.count)")
                    NavigationLink {
                        PostDetailView(post: post)
                    } label: {
                        HStack {
                            Image(systemName: "message")
                                .foregroundColor(Color.black)
                        }
                    }
                    //Text("\(post.commentsRef.count)")
                    Text("0")
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
