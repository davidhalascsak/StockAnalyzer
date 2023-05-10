import Foundation
import SwiftUI
import PhotosUI
import FirebaseAuth

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var user: User?
    @Published var alertTitle: String = ""
    @Published var alertText: String = ""
    @Published var selectedPhoto: PhotosPickerItem?
    @Published var showAlert: Bool = false
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
            isLoading = false
            return
        }
        
        user = await userService.fetchUser(id: id)
        user?.image = await imageService.fetchImageData(url: user?.imageUrl ?? "")
        isLoading = false
    }
    
    func updatePicture(data: Data) async {
        if let user = user {
            let result = await imageService.updateImage(url: user.imageUrl, data: data)
            self.isUpdatingProfile = false
            
            if result == false {
                alertTitle = "Error"
                alertText = "The change of the profile picture was unsuccessful."
                showAlert.toggle()
            }
        }
    }
    
    func logout() {
        _ = sessionService.logout()
        user = nil
    }

}
