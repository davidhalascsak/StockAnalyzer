import SwiftUI
import Firebase

struct CommentSectionView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel: CommentSectionViewModel

    init(post: Post, commentService: CommentServiceProtocol, userService: UserServiceProtocol, sessionService: SessionServiceProtocol, imageService: ImageServiceProtocol) {
        _viewModel = StateObject(wrappedValue: CommentSectionViewModel(post: post, commentService: commentService, userService: userService, sessionService: sessionService, imageService: imageService))
    }
    
    var body: some View {
        NavigationStack {
            commentSectionView
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("Comments")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Image(systemName: "arrowshape.backward")
                    .onTapGesture {
                        dismiss()
                    }
            }
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button("Ok", role: .cancel) {
                viewModel.alertTitle = ""
                viewModel.alertText = ""
            }
        } message: {
            Text(viewModel.alertText)
        }
    }
    
    var commentSectionView: some View {
        VStack(alignment: .leading) {
            if !viewModel.isLoading {
                ScrollView(showsIndicators: false) {
                    ForEach(viewModel.comments) { comment in
                        CommentView(post: viewModel.post, comment: comment, commentService: CommentService(), sessionService: SessionService())
                        Divider()
                    }
                }
                if viewModel.sessionService.getUserId() != nil {
                    NewCommentView(viewModel: viewModel)
                } else {
                    Color.white
                        .frame(height: 25)
                        .frame(maxWidth: .infinity)
                }
            } else {
                Spacer()
                ProgressView()
                Spacer()
            }
        }
        .task {
            viewModel.isLoading = true
            await viewModel.fetchComments()
        }
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let user = CurrentUser(username: "istengyermeke", email: "david.halascsak@gmail.com", country: "Hungary", imageUrl: "")
        let post = Post(userRef: "asd", body: "Buy Tesla", likeCount: 5, commentCount: 5, stockSymbol: "", timestamp: Timestamp(date: Date()), user: user)
        CommentSectionView(post: post, commentService: MockCommentService(currentUser: nil), userService: MockUserService(), sessionService: MockSessionService(currentUser: nil), imageService: ImageService())
    }
}


