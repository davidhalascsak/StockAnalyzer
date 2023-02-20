import SwiftUI
import Firebase

struct CommentView: View {
    @ObservedObject var vm: CommentViewModel
    
    init(post: Post, comment: Comment) {
        _vm = ObservedObject(wrappedValue: CommentViewModel(post: post, comment: comment))
    }
    
    var body: some View {
        HStack(alignment: .top) {
            Rectangle()
                .frame(width: 40, height: 40)
                .cornerRadius(10)
            VStack(alignment: .leading) {
                Text(vm.comment.user?.username ?? "")
                    .foregroundColor(.blue)
                    .font(.headline)
                Text(vm.comment.user?.location ?? "")
                    .font(.subheadline)
                Text(vm.comment.body)
                    .multilineTextAlignment(.leading)
                    .padding(.vertical)
                HStack {
                    Image(systemName: vm.comment.isLiked ?? false ? "hand.thumbsup.fill" : "hand.thumbsup")
                        .foregroundColor(vm.comment.isLiked ?? false ? Color.blue : Color.black)
                        .onTapGesture {
                            vm.comment.isLiked ?? false ? vm.unlikeComment() : vm.likeComment()
                        }
                    Text("\(vm.comment.likes)")
                }
            }
        }
        .padding()
    }
}
/*
 struct CommentView_Previews: PreviewProvider {
 static var previews: some View {
 let user = User(username: "istengyermeke", email: "david.halascsak@gmail.com", location: "Hungary")
 let post = Comment(userRef: "asd", body: "Buy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy Tesla", timestamp: Timestamp(date: Date()), likes: 5, user: user)
 
 CommentView(comment: post)
 }
 }
 */
