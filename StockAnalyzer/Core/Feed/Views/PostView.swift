import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct PostView: View {
    var vm: PostViewModel
    
    init(post: Post) {
        vm = PostViewModel(post: post)
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack() {
                    Rectangle()
                        .frame(width: 40, height: 40)
                        .cornerRadius(10)
                    VStack(alignment: .leading) {
                        Text(vm.post.user?.username ?? "")
                            .foregroundColor(.blue)
                            .font(.headline)
                        Text(vm.post.user?.location ?? "")
                            .font(.subheadline)
                    }
                }
                
                Text(vm.post.body)
                    .multilineTextAlignment(.leading)
                    .padding(.vertical)
                HStack {
                    Image(systemName: "hand.thumbsup")
                        .onTapGesture {
                            vm.updateLikes()
                        }
                    Text("\(vm.post.likes)")
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        }
    }
}

 struct PostView_Previews: PreviewProvider {
 
    static var previews: some View {
        let user = User(username: "istengyermeke", email: "david.halascsak@gmail.com", location: "Hungary")
        let post = Post(userRef: "asd", body: "Buy Tesla", likes: 5, user: user)

        PostView(post: post)
    }
 }
 
