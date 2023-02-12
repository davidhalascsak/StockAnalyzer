import SwiftUI

struct PostDetailView: View {
    @StateObject private var vm: PostViewModel
    
    init(post: Post) {
        _vm = StateObject(wrappedValue: PostViewModel(post: post))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                if let comments = vm.post.comments {
                    ForEach(comments) { comment in
                        Text(comment.body)
                    }
                }
            }
        }
    }
}
/*
 struct PostDetailView_Previews: PreviewProvider {
 static var previews: some View {
 PostDetailView()
 }
 }
 */
