import SwiftUI
import Firebase

struct CommentView: View {
    @ObservedObject var vm: CommentViewModel
    
    
    init(post: Post, comment: Comment, commentService: CommentServiceProtocol) {
        _vm = ObservedObject(wrappedValue: CommentViewModel(post: post, comment: comment, commentService: commentService))
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
                HStack {
                    Text(vm.comment.user?.location ?? "")
                        .font(.subheadline)
                    Text("•")
                    Text(toDate(stamp: vm.comment.timestamp))
                }
                Text(vm.comment.body)
                    .multilineTextAlignment(.leading)
                    .padding(.vertical, 5)
                HStack {
                    Image(systemName: vm.comment.isLiked ?? false ? "hand.thumbsup.fill" : "hand.thumbsup")
                        .foregroundColor(vm.comment.isLiked ?? false ? Color.blue : Color.black)
                        .onTapGesture {
                            if vm.commentService.isUpdated {
                                vm.commentService.isUpdated = false
                                if vm.comment.isLiked ?? false {
                                    Task {
                                        await vm.unlikeComment()
                                    }
                                } else {
                                    Task {
                                        await vm.likeComment()
                                    }
                                }
                            }
                        }
                    Text("\(vm.comment.likes)")
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}


 struct CommentView_Previews: PreviewProvider {
     static let user = User(username: "istengyermeke", email: "david.halascsak@gmail.com", location: "Hungary")
     static let post = Post(userRef: "asd", body: "Elon is the king", timestamp: Timestamp(date: Date()), likes: 2, comments: 1)
         
     static let comment = Comment(userRef: "asd", body: "Buy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy Tesla", timestamp: Timestamp(date: Date()), likes: 5, user: user)
     
     static var previews: some View {
         CommentView(post: post, comment: comment, commentService: CommentService())
     }
 }
 
