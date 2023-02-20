import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

struct PostView: View {
    @ObservedObject var vm: PostViewModel
    
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
                        HStack {
                            Text(vm.post.user?.location ?? "")
                                .font(.subheadline)
                            Text("•")
                            Text(toDate(stamp: vm.post.timestamp))
                        }
                    }
                }
                
                Text(vm.post.body)
                    .multilineTextAlignment(.leading)
                    .padding(.vertical)
                HStack {
                    Image(systemName: vm.post.isLiked ?? false ? "hand.thumbsup.fill" : "hand.thumbsup")
                        .foregroundColor(vm.post.isLiked ?? false ? Color.blue : Color.black)
                        .onTapGesture {
                            vm.post.isLiked ?? false ? vm.unlikePost() : vm.likePost()
                        }
                    Text("\(vm.post.likes)")
                    NavigationLink {
                        PostDetailView(post: vm.post)
                    } label: {
                        Image(systemName: "message")
                            .foregroundColor(Color.black)
                    }
                    Text("\(vm.post.comments)")
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        }
    }
    
    func toDate(stamp: Timestamp) -> String {
        let difference = Date().timeIntervalSince(stamp.dateValue())
        let diffInMinutes = difference / 60
        
        if diffInMinutes < 60 {
            return "\(String(format: "%.0f", diffInMinutes))m"
        } else if diffInMinutes >= 60 && diffInMinutes < 24 * 60 {
            return "\(String(format: "%.0f", diffInMinutes / 60))h"
        } else if diffInMinutes >= 24 * 60 && diffInMinutes < 7 * 24 * 60 {
            return "\(String(format: "%.0f", diffInMinutes / (60 * 24)))d"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            
            return formatter.string(from: stamp.dateValue())
        }
    }
}

 struct PostView_Previews: PreviewProvider {
 
    static var previews: some View {
        let user = User(username: "istengyermeke", email: "david.halascsak@gmail.com", location: "Hungary")
        let post = Post(userRef: "asd", body: "Buy Tesla", timestamp: Timestamp(date: Date()), likes: 5, comments: 5, user: user)
        PostView(post: post)
    }
 }
 
