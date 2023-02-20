import SwiftUI

struct NewPostView: View {
    @Environment(\.dismiss) private var dismiss
    @State var textContent: String = ""
    @FocusState var focusedField: FocusedField?
    let postService = PostService()
    
    enum FocusedField {
        case field
    }
    
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Type here...", text: $textContent, axis: .vertical)
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
                        .foregroundColor(Color.black.opacity(textContent.count > 0 ? 1.0 : 0.5))
                        .onTapGesture {
                            if self.textContent.count > 0 {
                                postService.createPost(body: textContent) {
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
        NewPostView()
    }
}