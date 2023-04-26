import SwiftUI

struct NewCommentView: View {
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
/*
struct NewCommentView_Previews: PreviewProvider {
    static var previews: some View {
        NewCommentView(vm: )
    }
}
*/
