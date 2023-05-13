import SwiftUI
import Firebase

struct NewCommentView: View {
    @ObservedObject private var viewModel: CommentSectionViewModel
    
    var body: some View {
        HStack {
            ImageView(url: viewModel.post.user?.imageUrl ?? "", defaultImage: "", imageService: ImageService())
                .frame(width: 40, height: 40)
                .cornerRadius(10)
            HStack {
                TextField("Add a comment..", text: $viewModel.commentBody)
                    .autocorrectionDisabled()
                Image(systemName: "paperplane.circle.fill")
                    .font(.title2)
                    .foregroundColor(Color.blue.opacity(viewModel.commentBody.count > 0 ? 1.0 : 0.6))
                    .onTapGesture {
                        if viewModel.commentBody.count > 0 {
                            Task {
                                await viewModel.createComment()
                            }
                        }
                    }
            }
            .padding(6)
            .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
            )
        }
        .padding()
    }
}

struct NewCommentView_Previews: PreviewProvider {
    static let user = User(username: "istengyermeke", email: "david.halascsak@gmail.com", location: "Hungary", imageUrl: "")
    static let post = Post(userRef: "asd", body: "Buy Tesla", timestamp: Timestamp(date: Date()), likes: 5, comments: 5, symbol: "", user: user)
    static let viewModel = CommentSectionViewModel(post: post, commentService: MockCommentService(currentUser: nil), userService: MockUserService(), sessionService: MockSessionService(currentUser: nil), imageService: ImageService())
    
    static var previews: some View {
        NewCommentView(viewModel: viewModel)
    }
}

