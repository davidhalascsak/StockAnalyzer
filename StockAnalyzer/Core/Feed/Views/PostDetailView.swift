import SwiftUI
import Firebase

struct PostDetailView: View {
    @ObservedObject var vm: PostDetailViewModel
    @State var commentText = ""

    init(post: Post) {
        _vm = ObservedObject(wrappedValue: PostDetailViewModel(post: post))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                ForEach(vm.comments) { comment in
                    CommentView(post: vm.post, comment: comment)
                }
            }
            HStack {
                Rectangle()
                    .frame(width: 40, height: 40)
                    .cornerRadius(10)
                TextField("asd", text: $commentText)
            }
            .padding()
        }
        .onAppear(perform: vm.fetchComments)
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
        let post = Post(userRef: "asd", body: "Buy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy TeslaBuy Tesla", timestamp: Timestamp(date: Date()), likes: 5, comments: 5, user: user)
        PostDetailView(post: post)
    }
}
