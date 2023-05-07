import SwiftUI
import Firebase

struct CommentSectionView: View {
    @StateObject var vm: CommentSectionViewModel
    @Environment(\.dismiss) private var dismiss

    init(post: Post, commentService: CommentServiceProtocol, userService: UserServiceProtocol, sessionService: SessionServiceProtocol) {
        _vm = StateObject(wrappedValue: CommentSectionViewModel(post: post, commentService: commentService, userService: userService, sessionService: sessionService))
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                if vm.isLoading == false {
                    ScrollView(showsIndicators: false) {
                        ForEach(vm.comments) { comment in
                            CommentView(post: vm.post, comment: comment, commentService: CommentService(), sessionService: SessionService())
                            Divider()
                        }
                    }
                    if vm.sessionService.getUserId() != nil {
                        NewCommentView(vm: vm)
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
                await vm.fetchComments()
            }
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
        .alert(vm.alertTitle, isPresented: $vm.showAlert) {
            Button("Ok", role: .cancel) {
                vm.alertTitle = ""
                vm.alertText = ""
            }
        } message: {
            Text(vm.alertText)
        }
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let user = User(username: "istengyermeke", email: "david.halascsak@gmail.com", location: "Hungary", imageUrl: "")
        let post = Post(userRef: "asd", body: "Buy Tesla", timestamp: Timestamp(date: Date()), likes: 5, comments: 5, symbol: "", user: user)
        CommentSectionView(post: post, commentService: MockCommentService(currentUser: nil), userService: MockUserService(), sessionService: MockSessionService(currentUser: nil))
    }
}


