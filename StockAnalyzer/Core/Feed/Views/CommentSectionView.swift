import SwiftUI
import Firebase

struct CommentSectionView: View {
    @StateObject var vm: CommentSectionViewModel

    init(post: Post) {
        _vm = StateObject(wrappedValue: CommentSectionViewModel(post: post))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(showsIndicators: false) {
                ForEach(vm.comments) { comment in
                    CommentView(post: vm.post, comment: comment)
                }
            }
            ExtractedView(vm: vm)
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
        CommentSectionView(post: post)
    }
}

struct ExtractedView: View {
    @ObservedObject var vm: CommentSectionViewModel
    @State var textContent: String = ""
    
    var body: some View {
        HStack {
            Rectangle()
                .frame(width: 40, height: 40)
                .cornerRadius(10)
            TextField("asd", text: $textContent)
            
            Image(systemName: "paperplane.circle.fill")
                .font(.title2)
                .foregroundColor(Color.blue.opacity(textContent.count > 0 ? 1.0 : 0.5))
                .onTapGesture {
                    if textContent.count > 0 {
                        vm.createComment(body: textContent)
                        textContent = ""
                    }
                }
        }
        .padding()
    }
}
