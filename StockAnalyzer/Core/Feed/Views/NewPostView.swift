import SwiftUI

struct NewPostView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: FocusField?
    
    @StateObject private var viewModel: NewPostViewModel
    
    private enum FocusField: Hashable {
        case newPostField
    }

    init(stockSymbol: String?, postService: PostServiceProtocol) {
        _viewModel = StateObject(wrappedValue: NewPostViewModel(stockSymbol: stockSymbol, postService: postService))
    }
    
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Type here...", text: $viewModel.postBody, axis: .vertical)
                    .autocorrectionDisabled()
                    .focused($focusedField, equals: .newPostField)
                    .padding()
                Spacer()
            }
            .navigationBarBackButtonHidden()
            .navigationTitle("Write a Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Text("Post")
                        .foregroundColor(Color.primary.opacity(viewModel.postBody.count > 0 ? 1.0 : 0.5))
                        .onTapGesture {
                            if viewModel.postBody.count > 0 {
                                Task {
                                    await viewModel.createPost()
                                    if !viewModel.showAlert {
                                        dismiss()
                                    }
                                }
                            }
                        }
                }
                ToolbarItem(placement: .navigationBarLeading){
                    Text("Cancel")
                        .onTapGesture {
                            dismiss()
                        }
                }
            }
            .onAppear {
                self.focusedField = .newPostField
            }
            .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
                Button("Ok", role: .cancel) {
                    viewModel.alertTitle = ""
                    viewModel.alertText = ""
                    dismiss()
                }
            } message: {
                Text(viewModel.alertText)
            }
        }
    }
}

struct NewPostView_Previews: PreviewProvider {
    static var previews: some View {
        NewPostView(stockSymbol: nil, postService: MockPostService(currentUser: nil))
    }
}
