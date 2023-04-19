import Foundation
import SwiftUI
import PhotosUI
import FirebaseAuth

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var user: User?
    @Published var selectedPhoto: PhotosPickerItem?
    
    let userService: UserServiceProtocol
    let sessionService: SessionServiceProtocol
    let imageService: ImageServiceProtocol
    
    init(userService: UserServiceProtocol, sessionService: SessionServiceProtocol, imageService: ImageServiceProtocol) {
        self.userService = userService
        self.sessionService = sessionService
        self.imageService = imageService
    }
    
    func fetchUser() async {
        guard let id = Auth.auth().currentUser?.uid else {return}
        
        self.user = await userService.fetchUser(id: id)
        self.user?.image = await imageService.fetchData(url: user?.imageUrl ?? "")
    }
}
