import SwiftUI

enum FocusedField {
    case newPostField
    case baseField
    case growthRateField
    case discountRateField
    case terminalMultipleField
    case unitField
    case priceField
}

struct NewPostView: View {
    @StateObject var vm: NewPostViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState var focusedField: FocusedField?
    
    init(symbol: String?, postService: PostServiceProtocol) {
        _vm = StateObject(wrappedValue: NewPostViewModel(symbol: symbol, postService: postService))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Type here...", text: $vm.postBody, axis: .vertical)
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
                        .foregroundColor(Color.black.opacity(vm.postBody.count > 0 ? 1.0 : 0.5))
                        .onTapGesture {
                            if vm.postBody.count > 0 {
                                Task {
                                    await vm.createPost()
                                    if !vm.showAlert {
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
            .alert(vm.alertTitle, isPresented: $vm.showAlert) {
                Button("Ok", role: .cancel) {
                    vm.alertTitle = ""
                    vm.alertText = ""
                    dismiss()
                }
            } message: {
                Text(vm.alertText)
            }
        }
    }
}

struct NewPostView_Previews: PreviewProvider {
    static var previews: some View {
        NewPostView(symbol: "APPL", postService: MockPostService(currentUser: nil))
    }
}
