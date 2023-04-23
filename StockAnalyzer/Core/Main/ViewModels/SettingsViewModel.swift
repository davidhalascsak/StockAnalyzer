import Foundation
import SwiftUI
import PhotosUI
import FirebaseAuth

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var user: User?
    @Published var selectedPhoto: PhotosPickerItem?
    @Published var isLoading: Bool = true
    @Published var isUpdatingProfile: Bool = false
    
    let userService: UserServiceProtocol
    let sessionService: SessionServiceProtocol
    let imageService: ImageServiceProtocol
    
    init(userService: UserServiceProtocol, sessionService: SessionServiceProtocol, imageService: ImageServiceProtocol) {
        self.userService = userService
        self.sessionService = sessionService
        self.imageService = imageService
    }
    
    func fetchUser() async {
        guard let id = sessionService.getUserId() else {
            self.isLoading = false
            return
        }
        
        self.user = await userService.fetchUser(id: id)
        self.user?.image = await imageService.fetchData(url: user?.imageUrl ?? "")
        self.isLoading = false
    }
    
    func updatePicture(data: Data) async {
        if let user = self.user {
            _ = await imageService.updateImage(url: user.imageUrl, data: data)
            self.isUpdatingProfile = false
        }
    }
    
    func logout() {
        _ = self.sessionService.logout()
        self.user = nil
    }

}
