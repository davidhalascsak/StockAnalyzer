import SwiftUI
import Firebase

struct CommentView: View {
    @ObservedObject private var viewModel: CommentViewModel
    
    init(post: Post, comment: Comment, commentService: CommentServiceProtocol, sessionService: SessionServiceProtocol) {
        _viewModel = ObservedObject(wrappedValue: CommentViewModel(post: post, comment: comment, commentService: commentService, sessionService: sessionService))
    }
    
    var body: some View {
        HStack(alignment: .top) {
            ImageView(url: viewModel.post.user?.imageUrl ?? "", defaultImage: "", imageService: ImageService())
                .frame(width: 40, height: 40)
                .cornerRadius(10)
            VStack(alignment: .leading) {
                Text(viewModel.comment.user?.username ?? "")
                    .foregroundColor(.blue)
                    .font(.headline)
                HStack {
                    Text(viewModel.comment.user?.country ?? "")
                        .font(.subheadline)
                    Text("•")
                    Text(toDate(stamp: viewModel.comment.timestamp))
                }
                Text(viewModel.comment.body)
                    .multilineTextAlignment(.leading)
                    .padding(.vertical, 5)
                HStack {
                    Image(systemName: viewModel.comment.isLiked ?? false ? "hand.thumbsup.fill" : "hand.thumbsup")
                        .foregroundColor(viewModel.comment.isLiked ?? false ? Color.blue : Color.primary)
                        .onTapGesture {
                            if viewModel.sessionService.getUserId() != nil && viewModel.isUpdated {
                                if viewModel.comment.isLiked ?? false {
                                    Task {
                                        await viewModel.unlikeComment()
                                    }
                                } else {
                                    Task {
                                        await viewModel.likeComment()
                                    }
                                }
                            }
                        }
                    Text("\(viewModel.comment.likeCount)")
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}


 struct CommentView_Previews: PreviewProvider {
     static let user = CurrentUser(username: "istengyermeke", email: "david.halascsak@gmail.com", country: "Hungary", imageUrl: "")
     static let post = Post(userRef: "asd", body: "Elon is the king", likeCount: 2, commentCount: 1, stockSymbol: "",timestamp: Timestamp(date: Date()))
         
     static let comment = Comment(userRef: "asd", body: "Buy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy Tesla", timestamp: Timestamp(date: Date()), likeCount: 5, user: user)
     
     static var previews: some View {
         CommentView(post: post, comment: comment, commentService: MockCommentService(currentUser: nil), sessionService: MockSessionService(currentUser: nil))
     }
 }
 
