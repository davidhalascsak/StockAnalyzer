import XCTest

@testable import StockAnalyzer

@MainActor
final class SettingsViewModel_Tests: XCTestCase {
    func test_SettingsViewModel_fetchUser_shouldReturnNil() async throws {
        //Given
        let authUser: TestAuthenticationUser? = nil
        let vm = SettingsViewModel(userService: MockUserService(), sessionService: MockSessionService(currentUser: authUser), imageService: MockImageService())
        
        //When
        await vm.fetchUser()
        
        //Then
        XCTAssertNil(vm.user)
        XCTAssertFalse(vm.isLoading)
    }
    
     func test_SettingsViewModel_fetchUser_shouldReturnNotNil() async throws {
        //Given
         let authUser: TestAuthenticationUser? = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
         let vm = SettingsViewModel(userService: MockUserService(), sessionService: MockSessionService(currentUser: authUser), imageService: MockImageService())
        
         //When
        await vm.fetchUser()
        
        //Then
        XCTAssertNotNil(vm.user)
        XCTAssertNotNil(vm.user?.image)
        XCTAssertFalse(vm.isLoading)
    }
    
    func test_SettingsViewModel_logout() async throws {
        //Given
        let authUser: TestAuthenticationUser? = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let vm = SettingsViewModel(userService: MockUserService(), sessionService: MockSessionService(currentUser: authUser), imageService: MockImageService())
        //When

        try? await vm.sessionService.login(email: "david@domain.com", password: "asd123")
        await vm.fetchUser()
        vm.logout()

        //Then
        XCTAssertNil(vm.user)
   }
    
    func test_SettingsViewModel_updatePicture_ShouldBeUnsuccessful() async throws {
        //Given
        let authUser: TestAuthenticationUser? = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let vm = SettingsViewModel(userService: MockUserService(), sessionService: MockSessionService(currentUser: authUser), imageService: MockImageService())
        let data = Data()
        //When

        try? await vm.sessionService.login(email: "david@domain.com", password: "asd123")
        await vm.fetchUser()
        await vm.updatePicture(data: data)

        //Then
        XCTAssertFalse(vm.isUpdatingProfile)
        XCTAssertTrue(vm.showAlert)
        XCTAssertEqual("Error", vm.alertTitle)
        XCTAssertEqual("The change of the profile picture was unsuccessful.", vm.alertText)
    }
    
    func test_SettingsViewModel_updatePicture_ShouldBeSuccessful() async throws {
        //Given
        let authUser: TestAuthenticationUser? = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let vm = SettingsViewModel(userService: MockUserService(), sessionService: MockSessionService(currentUser: authUser), imageService: MockImageService())
        let image = UIImage(named: "default_avatar")
        let data = image?.jpegData(compressionQuality: 0.5) ?? Data()
        
        //When

        try? await vm.sessionService.login(email: "david@domain.com", password: "asd123")
        await vm.fetchUser()
        await vm.updatePicture(data: data)

        //Then
        XCTAssertFalse(vm.isUpdatingProfile)
        XCTAssertFalse(vm.showAlert)
        XCTAssertEqual("", vm.alertTitle)
        XCTAssertEqual("", vm.alertText)
    }
    
    
}
