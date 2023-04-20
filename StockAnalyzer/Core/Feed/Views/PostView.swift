import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

struct PostView: View {
    @ObservedObject var vm: PostViewModel
    
    init(post: Post, postService: PostServiceProtocol, sessionService: SessionServiceProtocol) {
        _vm = ObservedObject(wrappedValue: PostViewModel(post: post, postService: postService, sessionService: sessionService))
    }
    
    var body: some View {
        NavigationStack {
            postRowView
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
        }
    }
    
    var postRowView: some View {
        VStack(alignment: .leading) {
            HStack() {
                ImageView(url: vm.post.user?.imageUrl ?? "", defaultImage: "", imageService: ImageService())
                    .frame(width: 40, height: 40)
                    .cornerRadius(10)
                VStack(alignment: .leading) {
                    Text(vm.post.user?.username ?? "")
                        .foregroundColor(.blue)
                        .font(.headline)
                    HStack {
                        Text(vm.post.user?.location ?? "")
                            .font(.subheadline)
                        Text("•")
                        Text(toDate(stamp: vm.post.timestamp))
                    }
                }
            }
        
            Text(vm.post.body)
                .multilineTextAlignment(.leading)
                .padding(.vertical, 5)
            HStack {
                Image(systemName: vm.post.isLiked ?? false ? "hand.thumbsup.fill" : "hand.thumbsup")
                    .foregroundColor(vm.post.isLiked ?? false ? Color.blue : Color.black)
                    .onTapGesture {
                        if vm.sessionService.getUserId() != nil && vm.postService.isUpdated {
                            vm.postService.isUpdated = false
                            if vm.post.isLiked ?? false {
                                
                                Task {
                                    await vm.unlikePost()
                                }
                            } else {
                                Task {
                                    await vm.likePost()
                                }
                            }
                        }
                    }
                Text("\(vm.post.likes)")
                NavigationLink {
                    CommentSectionView(post: vm.post, commentService: CommentService(), userService: UserService(), sessionService: SessionService())
                } label: {
                    Image(systemName: "message")
                        .foregroundColor(Color.black)
                }
                Text("\(vm.post.comments)")
            }
        }
    } 
}

 struct PostView_Previews: PreviewProvider {
 
    static var previews: some View {
        let user = User(username: "istengyermeke", email: "david.halascsak@gmail.com", location: "Hungary", imageUrl: "")
        let post = Post(userRef: "asd", body: "Buy Tesla", timestamp: Timestamp(date: Date()), likes: 5, comments: 5, user: user)
        PostView(post: post, postService: PostService(), sessionService: SessionService())
    }
 }
