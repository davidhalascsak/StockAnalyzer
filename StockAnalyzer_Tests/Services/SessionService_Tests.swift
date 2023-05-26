import XCTest

@testable import StockAnalyzer

@MainActor
final class SessionService_Tests: XCTestCase {

    func test_SessionService_getUserId_UserSignedIn() throws {
        //Given
        let user = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let sessionService = MockSessionService(currentUser: user)
        
        //When
        let id = sessionService.getUserId()
        
        //Then
        XCTAssertEqual("asd123", id)
    }

    func test_SessionService_getUserId_UserNotSignedIn() throws {
        //Given
        let sessionService = MockSessionService(currentUser: nil)
        
        //When
        let id = sessionService.getUserId()
        
        //Then
        XCTAssertNil(id)
    }
    
    func test_SessionService_login_WrongEmail() async throws {
        //Given
        let sessionService = MockSessionService(currentUser: nil)
        
        //When
        do {
            try await sessionService.login(email: "davidd@domain.com", password: "asd123")
        } catch let error {
            //Then
            XCTAssertEqual("There is no user record corresponding to this identifier. The user may have been deleted.", error.localizedDescription)
        }
    }
    
    func test_SessionService_login_WrongPassword() async throws {
        //Given
        let sessionService = MockSessionService(currentUser: nil)
        
        //When
        do {
            try await sessionService.login(email: "david@domain.com", password: "asd111")
        } catch let error {
            //Then
            XCTAssertEqual("The password does not match", error.localizedDescription)
        }
    }
    
    func test_SessionService_login_Successful() async throws {
        //Given
        let sessionService = MockSessionService(currentUser: nil)
        
        //When
        try? await sessionService.login(email: "david@domain.com", password: "asd123")
        
        //Then
        XCTAssertNotNil(sessionService.currentUser)
    }
    
    func test_SessionService_isUserVerified_true() async throws {
        //Given
        let user = TestAuthenticationUser(id: "asd123", email: "david@domain.com", password: "asd123", isVerified: true)
        let sessionService = MockSessionService(currentUser: user)
        
        //When
        let result = await sessionService.isUserVerified()
        
        //Them
        XCTAssertTrue(result)
    }
    
    func test_SessionService_isUserVerified_false() async throws {
        //Given
        let user = TestAuthenticationUser(id: "asd321", email: "bob@domain.com", password: "asd123", isVerified: false)
        let sessionService = MockSessionService(currentUser: user)
        
        //When
        let result = await sessionService.isUserVerified()
        
        //Them
        XCTAssertFalse(result)
    }
    
    func test_SessionService_logout_userSignedIn() throws {
        //Given
        let user = TestAuthenticationUser(id: "asd321", email: "bob@domain.com", password: "asd123", isVerified: false)
        let sessionService = MockSessionService(currentUser: user)
        
        //When
        let result = sessionService.logout()
        
        //Them
        XCTAssertTrue(result)
        XCTAssertNil(sessionService.currentUser)
    }
    
    func test_SessionService_logout_userNotSignedIn() throws {
        //Given
        let sessionService = MockSessionService(currentUser: nil)
        
        //When
        let result = sessionService.logout()
        
        //Them
        XCTAssertFalse(result)
        XCTAssertNil(sessionService.currentUser)
    }
    
    func test_SessionService_register_emailAlreadyInUse() async throws {
        //Given
        let sessionService = MockSessionService(currentUser: nil)
        
        //when
        do {
            try await sessionService.register(email: "bob@domain.com", password: "asd123")
        } catch let error {
            //Then
            XCTAssertEqual("The email is already in use!", error.localizedDescription)
        }
    }
    
    func test_SessionService_register_emailNotInUse() async throws {
        //Given
        let sessionService = MockSessionService(currentUser: nil)
        
        //when
        try await sessionService.register(email: "bobby@domain.com", password: "asd123")
        
        //Then
        XCTAssertNotNil(sessionService.currentUser)
        XCTAssertEqual("bobby@domain.com", sessionService.currentUser?.email)
    }
    
    func test_SessionService_delete_userSignedIn() async throws {
        //Given
        let user = TestAuthenticationUser(id: "asd321", email: "bob@domain.com", password: "asd123", isVerified: false)
        let sessionService = MockSessionService(currentUser: user)
        
        //when
        let result = await sessionService.deleteUser()
        
        //Then
        XCTAssertTrue(result)
    }
    
    func test_SessionService_delete_userNotSignedIn() async throws {
        //Given
        let sessionService = MockSessionService(currentUser: nil)
        
        //when
        let result = await sessionService.deleteUser()
        
        //Then
        XCTAssertFalse(result)
    }
}
