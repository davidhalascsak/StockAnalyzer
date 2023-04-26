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
                        }
                    }
                    if vm.sessionService.getUserId() != nil {
                        CommentBoxView(vm: vm)
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
        let post = Post(userRef: "asd", body: "Buy Tesla", timestamp: Timestamp(date: Date()), likes: 5, comments: 5, user: user)
        CommentSectionView(post: post, commentService: CommentService(), userService: UserService(), sessionService: SessionService())
    }
}

struct CommentBoxView: View {
    @ObservedObject var vm: CommentSectionViewModel
    
    
    var body: some View {
        HStack {
            ImageView(url: vm.post.user?.imageUrl ?? "", defaultImage: "", imageService: ImageService())
                .frame(width: 40, height: 40)
                .cornerRadius(10)
            HStack {
                TextField("Add a comment..", text: $vm.commentBody)
                    .autocorrectionDisabled()
                Image(systemName: "paperplane.circle.fill")
                    .font(.title2)
                    .foregroundColor(Color.blue.opacity(vm.commentBody.count > 0 ? 1.0 : 0.5))
                    .onTapGesture {
                        if vm.commentBody.count > 0 {
                            Task {
                                await vm.createComment()
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
