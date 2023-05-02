import XCTest

@testable import StockAnalyzer

@MainActor
final class AuthViewModel_Tests: XCTestCase {
    func test_AuthViewModel_isLogin_shouldBeTrue() throws {
        //Given
        let isLogin: Bool = true
        let authUser: AuthUser? = nil
        //When
        let vm = AuthViewModel(isLogin: isLogin, userService: MockUserService(), sessionService: MockSessionService(currentUser: authUser), imageService: MockImageService())
        
        //Then
        XCTAssertTrue(vm.isLogin)
    }
    
    func test_AuthViewModel_isLogin_shouldBeFalse() throws {
        //Given
        let isLogin: Bool = false
        let authUser: AuthUser? = nil
        //When
        let vm = AuthViewModel(isLogin: isLogin, userService: MockUserService(), sessionService: MockSessionService(currentUser: authUser), imageService: MockImageService())
        
        //Then
        XCTAssertFalse(vm.isLogin)
    }
    
    func test_AuthViewModel_login_emailShouldBeShorterThanRequired() async throws {
        //Given
        let isLogin: Bool = true
        let authUser: AuthUser? = nil
        let vm = AuthViewModel(isLogin: isLogin, userService: MockUserService(), sessionService: MockSessionService(currentUser: authUser), imageService: MockImageService())
        
        //When
        vm.userData.email = "n@d"
        await vm.checkLogin()
        
        //Then
        XCTAssertTrue(vm.showAlert)
        XCTAssertEqual("Error", vm.alertTitle)
        XCTAssertEqual("The email must be at least 5 characters long!", vm.alertText)
    }
    
    func test_AuthViewModel_login_emailShouldBeLongEnough() async throws {
        //Given
        let isLogin: Bool = true
        let authUser: AuthUser? = nil
        let vm = AuthViewModel(isLogin: isLogin, userService: MockUserService(), sessionService: MockSessionService(currentUser: authUser), imageService: MockImageService())
        
        //When
        vm.userData.email = "n@d.c"
        await vm.checkLogin()
        
        //Then
        XCTAssertTrue(vm.showAlert)
        XCTAssertEqual("Error", vm.alertTitle)
        XCTAssertEqual("The password must be at least 6 characters long!", vm.alertText)
    }
    
    func test_AuthViewModel_login_validEmailFormatShouldBeTrue() async throws {
        //Given
        let isLogin: Bool = true
        let authUser: AuthUser? = nil
        let vm = AuthViewModel(isLogin: isLogin, userService: MockUserService(), sessionService: MockSessionService(currentUser: authUser), imageService: MockImageService())
        
        //When
        vm.userData.email = "david@domain.com"
        await vm.checkLogin()
        
        //Then
        XCTAssertTrue(vm.showAlert)
        XCTAssertEqual("Error", vm.alertTitle)
        XCTAssertEqual("The password must be at least 6 characters long!", vm.alertText)
    }
    
    func test_AuthViewModel_login_validEmailFormatShouldBeFalse() async throws {
        //Given
        let isLogin: Bool = true
        let authUser: AuthUser? = nil
        let vm = AuthViewModel(isLogin: isLogin, userService: MockUserService(), sessionService: MockSessionService(currentUser: authUser), imageService: MockImageService())
        
        //When
        vm.userData.email = "david@domain"
        await vm.checkLogin()
        
        //Then
        XCTAssertTrue(vm.showAlert)
        XCTAssertEqual("Error", vm.alertTitle)
        XCTAssertEqual("The email format is not valid!", vm.alertText)
    }
    
    func test_AuthViewModel_login_passwordShouldBeShorterThanRequired() async throws {
        //Given
        let isLogin: Bool = true
        let authUser: AuthUser? = nil
        let vm = AuthViewModel(isLogin: isLogin, userService: MockUserService(), sessionService: MockSessionService(currentUser: authUser), imageService: MockImageService())
        
        //When
        vm.userData.email = "david@domain.com"
        vm.userData.password = "asd"
        vm.userData.passwordAgain = "asd"
        await vm.checkLogin()

        //Then
        XCTAssertTrue(vm.showAlert)
        XCTAssertEqual("Error", vm.alertTitle)
        XCTAssertEqual("The password must be at least 6 characters long!", vm.alertText)
    }
    
    func test_AuthViewModel_login_userIsVerifiedTrue() async throws {
        //Given
        let isLogin: Bool = true
        let authUser: AuthUser? = nil
        let vm = AuthViewModel(isLogin: isLogin, userService: MockUserService(), sessionService: MockSessionService(currentUser: authUser), imageService: MockImageService())
        
        //When
        vm.userData.email = "david@domain.com"
        vm.userData.password = "asd123"
        await vm.checkLogin()
        
        //Then
        XCTAssertFalse(vm.showAlert)
    }
    
    func test_AuthViewModel_login_userIsVerifiedFalse() async throws {
        //Given
        let isLogin: Bool = true
        let authUser: AuthUser? = nil
        let vm = AuthViewModel(isLogin: isLogin, userService: MockUserService(), sessionService: MockSessionService(currentUser: authUser), imageService: MockImageService())
        
        //When
        vm.userData.email = "bob@domain.com"
        vm.userData.password = "asd123"
        await vm.checkLogin()
        
        //Then
        XCTAssertTrue(vm.showAlert)
        XCTAssertEqual("Verification Error", vm.alertTitle)
        XCTAssertEqual("You must verify your account!", vm.alertText)
    }
    
    func test_AuthViewModel_login_passwordDoesNotMatch() async throws {
        //Given
        let isLogin: Bool = true
        let authUser: AuthUser? = nil
        let vm = AuthViewModel(isLogin: isLogin, userService: MockUserService(), sessionService: MockSessionService(currentUser: authUser), imageService: MockImageService())
        
        //When
        vm.userData.email = "bob@domain.com"
        vm.userData.password = "asd321"
        await vm.checkLogin()
        
        //Then
        XCTAssertTrue(vm.showAlert)
        XCTAssertEqual("Login Error", vm.alertTitle)
        XCTAssertEqual("The password is not correct!", vm.alertText)
    }
    
    
    func test_AuthViewModel_login_userIsNotFound() async throws {
        //Given
        let isLogin: Bool = true
        let authUser: AuthUser? = nil
        let vm = AuthViewModel(isLogin: isLogin, userService: MockUserService(), sessionService: MockSessionService(currentUser: authUser), imageService: MockImageService())
        
        //When
        vm.userData.email = "domain@domain.com"
        vm.userData.password = "asd123"
        await vm.checkLogin()
        
        //Then
        XCTAssertTrue(vm.showAlert)
        XCTAssertEqual("Login Error", vm.alertTitle)
        XCTAssertEqual("The user is not found!", vm.alertText)
    }
    
    func test_AuthViewModel_login_shouldBeSuccessful() async throws {
        //Given
        let isLogin: Bool = true
        let authUser: AuthUser? = nil
        let vm = AuthViewModel(isLogin: isLogin, userService: MockUserService(), sessionService: MockSessionService(currentUser: authUser), imageService: MockImageService())
        
        //When
        vm.userData.email = "david@domain.com"
        vm.userData.password = "asd123"
        await vm.checkLogin()
        
        //Then
        XCTAssertFalse(vm.showAlert)
        XCTAssertEqual("", vm.alertTitle)
        XCTAssertEqual("", vm.alertText)
    }
    
    func test_AuthViewModel_registration_usernameShouldBeShorterThanRequired() async throws {
        //Given
        let isLogin: Bool = true
        let authUser: AuthUser? = nil
        let vm = AuthViewModel(isLogin: isLogin, userService: MockUserService(), sessionService: MockSessionService(currentUser: authUser), imageService: MockImageService())
        
        //When
        vm.userData.username = "abcd"
        await vm.checkRegistration()
        
        //Then
        XCTAssertTrue(vm.showAlert)
        XCTAssertEqual("Error", vm.alertTitle)
        XCTAssertEqual("The username must be at least 5 characters long!", vm.alertText)
    }
    
    
    func test_AuthViewModel_registration_usernameShouldBeLongEnough() async throws {
        //Given
        let isLogin: Bool = true
        let authUser: AuthUser? = nil
        let vm = AuthViewModel(isLogin: isLogin, userService: MockUserService(), sessionService: MockSessionService(currentUser: authUser), imageService: MockImageService())
        
        //When
        vm.userData.username = "abcde"
        await vm.checkRegistration()
        
        //Then
        XCTAssertTrue(vm.showAlert)
        XCTAssertEqual("Error", vm.alertTitle)
        XCTAssertEqual("The email must be at least 5 characters long!", vm.alertText)
    }
    
    func test_AuthViewModel_registration_emailShouldBeShorterThanRequired() async throws {
        //Given
        let isLogin: Bool = true
        let authUser: AuthUser? = nil
        let vm = AuthViewModel(isLogin: isLogin, userService: MockUserService(), sessionService: MockSessionService(currentUser: authUser), imageService: MockImageService())
        
        //When
        vm.userData.username = "abcde"
        vm.userData.email = "a@a"
        await vm.checkRegistration()
        
        //Then
        XCTAssertTrue(vm.showAlert)
        XCTAssertEqual("Error", vm.alertTitle)
        XCTAssertEqual("The email must be at least 5 characters long!", vm.alertText)
    }
    
   func test_AuthViewModel_registration_emailShouldBeInvalid() async throws {
        //Given
       let isLogin: Bool = true
       let authUser: AuthUser? = nil
       let vm = AuthViewModel(isLogin: isLogin, userService: MockUserService(), sessionService: MockSessionService(currentUser: authUser), imageService: MockImageService())
        
        //When
        vm.userData.username = "abcde"
        vm.userData.email = "user@domain"
        await vm.checkRegistration()
        
        //Then
        XCTAssertTrue(vm.showAlert)
        XCTAssertEqual("Error", vm.alertTitle)
        XCTAssertEqual("The email format is not valid!", vm.alertText)
    }
    
    func test_AuthViewModel_registration_emailShouldBeValid() async throws {
        //Given
        let isLogin: Bool = true
        let authUser: AuthUser? = nil
        let vm = AuthViewModel(isLogin: isLogin, userService: MockUserService(), sessionService: MockSessionService(currentUser: authUser), imageService: MockImageService())
        
        //When
        vm.userData.username = "abcde"
        vm.userData.email = "user@domain.com"
        await vm.checkRegistration()
        
        //Then
        XCTAssertTrue(vm.showAlert)
        XCTAssertEqual("Error", vm.alertTitle)
        XCTAssertEqual("The password must be at least 6 characters long!", vm.alertText)
    }
    
    func test_AuthViewModel_registration_passwordShorterThanRequired() async throws {
        //Given
        let isLogin: Bool = true
        let authUser: AuthUser? = nil
        let vm = AuthViewModel(isLogin: isLogin, userService: MockUserService(), sessionService: MockSessionService(currentUser: authUser), imageService: MockImageService())
        
        //When
        vm.userData.username = "abcde"
        vm.userData.email = "user@domain.com"
        vm.userData.password = "asd"
        await vm.checkRegistration()
        
        //Then
        XCTAssertTrue(vm.showAlert)
        XCTAssertEqual("Error", vm.alertTitle)
        XCTAssertEqual("The password must be at least 6 characters long!", vm.alertText)
    }
    
    func test_AuthViewModel_registration_passwordShouldBeLongEnough() async throws {
        //Given
        let isLogin: Bool = true
        let authUser: AuthUser? = nil
        let vm = AuthViewModel(isLogin: isLogin, userService: MockUserService(), sessionService: MockSessionService(currentUser: authUser), imageService: MockImageService())
        
        //When
        vm.userData.username = "abcde"
        vm.userData.email = "user@domain.com"
        vm.userData.password = "asd123"
        await vm.checkRegistration()
        
        //Then
        XCTAssertTrue(vm.showAlert)
        XCTAssertEqual("Error", vm.alertTitle)
        XCTAssertEqual("The two passwords does not match!", vm.alertText)
    }
    
    func test_AuthViewModel_registration_twoPasswordsDoesNotMatch() async throws {
        //Given
        let isLogin: Bool = true
        let authUser: AuthUser? = nil
        let vm = AuthViewModel(isLogin: isLogin, userService: MockUserService(), sessionService: MockSessionService(currentUser: authUser), imageService: MockImageService())
        
        //When
        vm.userData.username = "abcde"
        vm.userData.email = "user@domain.com"
        vm.userData.password = "asd123"
        vm.userData.password = "asd122"
        await vm.checkRegistration()
        
        //Then
        XCTAssertTrue(vm.showAlert)
        XCTAssertEqual("Error", vm.alertTitle)
        XCTAssertEqual("The two passwords does not match!", vm.alertText)
    }
    
    func test_AuthViewModel_registration_usernameInUseShouldBeTrue() async throws {
        //Given
        let isLogin: Bool = true
        let authUser: AuthUser? = nil
        let vm = AuthViewModel(isLogin: isLogin, userService: MockUserService(), sessionService: MockSessionService(currentUser: authUser), imageService: MockImageService())
        
        //When
        vm.userData.username = "david"
        vm.userData.email = "user@domain.com"
        vm.userData.password = "asd123"
        vm.userData.passwordAgain = "asd123"
        await vm.checkRegistration()
        
        //Then
        XCTAssertTrue(vm.showAlert)
        XCTAssertEqual("Registration Error", vm.alertTitle)
        XCTAssertEqual("The username is already in use!", vm.alertText)
    }
    
    func test_AuthViewModel_registration_emailIsAlreadyInUseShouldBeTrue() async throws {
        //Given
        let isLogin: Bool = true
        let authUser: AuthUser? = nil
        let vm = AuthViewModel(isLogin: isLogin, userService: MockUserService(), sessionService: MockSessionService(currentUser: authUser), imageService: MockImageService())
        
        //When
        vm.userData.username = "davidd"
        vm.userData.email = "david@domain.com"
        vm.userData.password = "asd123"
        vm.userData.passwordAgain = "asd123"
        await vm.checkRegistration()
        
        //Then
        XCTAssertTrue(vm.showAlert)
        XCTAssertEqual("Registration Error", vm.alertTitle)
        XCTAssertEqual("The email is already in use!", vm.alertText)
    }
    
    func test_AuthViewModel_registration_shouldBeSuccessful() async throws {
        //Given
        let isLogin: Bool = true
        let authUser: AuthUser? = nil
        let vm = AuthViewModel(isLogin: isLogin, userService: MockUserService(), sessionService: MockSessionService(currentUser: authUser), imageService: MockImageService())
        
        //When
        vm.userData.username = "davidd"
        vm.userData.email = "davidd@domain.com"
        vm.userData.password = "asd123"
        vm.userData.passwordAgain = "asd123"
        await vm.checkRegistration()
        
        //Then
        XCTAssertTrue(vm.showAlert)
        XCTAssertEqual("Success", vm.alertTitle)
        XCTAssertEqual("Please verify your account, before login!", vm.alertText)
    }
}
