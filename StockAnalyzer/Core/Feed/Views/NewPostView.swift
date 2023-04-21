import SwiftUI

struct NewPostView: View {
    @StateObject var vm: NewPostViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState var focusedField: FocusedField?
    
    enum FocusedField {
        case field
    }
    
    init(symbol: String?, postService: PostServiceProtocol) {
        _vm = StateObject(wrappedValue: NewPostViewModel(symbol: symbol, postService: postService))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Type here...", text: $vm.textContent, axis: .vertical)
                    .autocorrectionDisabled()
                    .focused($focusedField, equals: .field)
                    .padding()
                Spacer()
            }
            .navigationBarBackButtonHidden()
            .navigationTitle("Write a Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Text("Post")
                        .foregroundColor(Color.black.opacity(vm.textContent.count > 0 ? 1.0 : 0.5))
                        .onTapGesture {
                            if vm.textContent.count > 0 {
                                Task {
                                    await vm.createPost()
                                    dismiss()
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
                self.focusedField = .field
            }
        }
    }
}

struct NewPostView_Previews: PreviewProvider {
    static var previews: some View {
        NewPostView(symbol: "APPL", postService: PostService())
    }
}
