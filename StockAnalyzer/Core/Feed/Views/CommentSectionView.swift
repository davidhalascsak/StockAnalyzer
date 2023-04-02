import SwiftUI
import Firebase

struct CommentSectionView: View {
    @StateObject var vm: CommentSectionViewModel
    @Environment(\.dismiss) private var dismiss

    init(post: Post, commentService: CommentServiceProtocol, userService: UserServiceProtocol) {
        _vm = StateObject(wrappedValue: CommentSectionViewModel(post: post, commentService: commentService, userService: userService))
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                ScrollView(showsIndicators: false) {
                    ForEach(vm.comments) { comment in
                        CommentView(post: vm.post, comment: comment, commentService: CommentService())
                    }
                }
                if Auth.auth().currentUser != nil {
                    CommentBoxView(vm: vm)
                } else {
                    Color.white
                        .frame(height: 25)
                        .frame(maxWidth: .infinity)
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
    }
    
    func formatDate(stamp: Timestamp) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        return formatter.string(from: stamp.dateValue())
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let user = User(username: "istengyermeke", email: "david.halascsak@gmail.com", location: "Hungary")
        let post = Post(userRef: "asd", body: "Buy Tesla", timestamp: Timestamp(date: Date()), likes: 5, comments: 5, user: user)
        CommentSectionView(post: post, commentService: CommentService(), userService: UserService())
    }
}

struct CommentBoxView: View {
    @ObservedObject var vm: CommentSectionViewModel
    @State var textContent: String = ""
    
    var body: some View {
        HStack {
            Rectangle()
                .frame(width: 40, height: 40)
                .cornerRadius(10)
            HStack {
                TextField("Add a comment..", text: $textContent)
                    .autocorrectionDisabled()
                Image(systemName: "paperplane.circle.fill")
                    .font(.title2)
                    .foregroundColor(Color.blue.opacity(textContent.count > 0 ? 1.0 : 0.5))
                    .onTapGesture {
                        if textContent.count > 0 {
                            Task {
                                await vm.createComment(body: textContent)
                                textContent = ""
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
