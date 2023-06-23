import SwiftUI

struct FeedView: View {
    @State private var isNewPostPresented: Bool = false
    @State private var isSettingsPresented: Bool = false
    
    @StateObject private var viewModel: FeedViewModel
    
    init(stockSymbol: String?, userService: UserServiceProtocol, postService: PostServiceProtocol, sessionService: SessionServiceProtocol, imageService: ImageServiceProtocol) {
        _viewModel = StateObject(wrappedValue: FeedViewModel(stockSymbol: stockSymbol, userService: userService, postService: postService, sessionService: sessionService, imageService: imageService))
    }

    var body: some View {
        VStack(spacing: 0) {
            headerView
                .padding(.bottom, 5)
            Divider()
            if !viewModel.isLoading {
                feedView
                    .fullScreenCover(isPresented: $isNewPostPresented, content: {
                        NewPostView(stockSymbol: nil, postService: PostService())
                    })
                    .fullScreenCover(isPresented: $isSettingsPresented, content: {
                        SettingsView(userService: UserService(), sessionService: SessionService(), imageService: ImageService())
                    })
            } else {
                Spacer()
                ProgressView()
                Spacer()
            }
            Divider()
                .padding(.bottom, 5)
        }
        .onAppear() {
            Task {
                viewModel.isLoading = true
                await viewModel.fetchPosts()
            }
        }
        .onDisappear {
            viewModel.posts = []
            viewModel.isLoading = true
        }
    }
    
    var headerView: some View {
        HStack() {
            Image(systemName: "arrow.triangle.2.circlepath")
                .font(.title2)
                .onTapGesture {
                    withAnimation {
                        viewModel.isLoading = true
                        Task {
                            await viewModel.fetchPosts()
                        }
                        viewModel.shouldScroll.toggle()
                    }
                }
                .disabled(viewModel.isLoading)
            Spacer()
            Text("Feed")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color.blue)
            Spacer()
            Image(systemName: "person.crop.circle")
                .font(.title2)
                .onTapGesture {
                    isSettingsPresented.toggle()
                }
        }
        .padding(.horizontal)
    }

    var feedView: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                Divider().id("top")
                LazyVStack {
                    ForEach(viewModel.posts) { post in
                        PostView(post: post, postService: PostService(), sessionService: SessionService())
                        Divider()
                    }
                }
                .onChange(of: viewModel.shouldScroll) { _ in
                    withAnimation(.spring()) {
                        proxy.scrollTo("top")
                    }
                }
                .onChange(of: isNewPostPresented) { newValue in
                    if newValue == false {
                        viewModel.isLoading = true
                        Task {
                            await viewModel.fetchPosts()
                        }
                    }
                }
                .onChange(of: isSettingsPresented) { newValue in
                    if newValue == false {
                        viewModel.isLoading = true
                        Task {
                            await viewModel.fetchPosts()
                        }
                    }
                }
            }
            .overlay(alignment: .bottomTrailing) {
                if viewModel.sessionService.getUserId() != nil {
                    Image(systemName: "pencil")
                        .font(.title)
                        .foregroundColor(Color.white)
                        .frame(width: 50, height: 50)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .padding()
                        .onTapGesture {
                            isNewPostPresented.toggle()
                        }
                }
            }
        }
    }
}


struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(stockSymbol: nil, userService: MockUserService(), postService: MockPostService(currentUser: nil), sessionService: MockSessionService(currentUser: nil), imageService: MockImageService())
    }
}

