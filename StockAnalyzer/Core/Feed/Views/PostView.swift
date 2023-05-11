import SwiftUI
import Firebase

struct PostView: View {
    @ObservedObject private var viewModel: PostViewModel
    
    init(post: Post, postService: PostServiceProtocol, sessionService: SessionServiceProtocol) {
        _viewModel = ObservedObject(wrappedValue: PostViewModel(post: post, postService: postService, sessionService: sessionService))
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack() {
                    ImageView(url: viewModel.post.user?.imageUrl ?? "", defaultImage: "", imageService: ImageService())
                        .frame(width: 40, height: 40)
                        .cornerRadius(10)
                    VStack(alignment: .leading) {
                        Text(viewModel.post.user?.username ?? "")
                            .foregroundColor(.blue)
                            .font(.headline)
                        HStack {
                            Text(viewModel.post.user?.location ?? "")
                                .font(.subheadline)
                            Text("•")
                            Text(toDate(stamp: viewModel.post.timestamp))
                        }
                    }
                }
                Text(viewModel.post.body)
                    .multilineTextAlignment(.leading)
                    .padding(.vertical, 5)
                HStack {
                    Image(systemName: viewModel.post.isLiked ?? false ? "hand.thumbsup.fill" : "hand.thumbsup")
                        .foregroundColor(viewModel.post.isLiked ?? false ? Color.blue : Color.primary)
                        .onTapGesture {
                            if viewModel.sessionService.getUserId() != nil && viewModel.isUpdated {
                                if viewModel.post.isLiked ?? false {
                                    Task {
                                        await viewModel.unlikePost()
                                    }
                                } else {
                                    Task {
                                        await viewModel.likePost()
                                    }
                                }
                            }
                        }
                    Text("\(viewModel.post.likes)")
                    NavigationLink {
                        CommentSectionView(post: viewModel.post, commentService: CommentService(), userService: UserService(), sessionService: SessionService())
                    } label: {
                        Image(systemName: "message")
                            .foregroundColor(Color.primary)
                    }
                    Text("\(viewModel.post.comments)")
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

 struct PostView_Previews: PreviewProvider {
 
    static var previews: some View {
        let user = User(username: "istengyermeke", email: "david.halascsak@gmail.com", location: "Hungary", imageUrl: "")
        let post = Post(userRef: "asd", body: "Buy Tesla", timestamp: Timestamp(date: Date()), likes: 5, comments: 5, symbol: "", user: user)
        PostView(post: post, postService: MockPostService(currentUser: nil), sessionService: MockSessionService(currentUser: nil))
    }
 }
