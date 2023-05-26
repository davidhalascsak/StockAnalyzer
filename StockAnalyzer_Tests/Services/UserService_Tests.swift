import XCTest

@testable import StockAnalyzer

@MainActor
final class UserService_Tests: XCTestCase {

    func test_UserService_fetchAllUser() async throws {
        //Given
        let userService = MockUserService()
        
        //When
        let users = await userService.fetchAllUser()
        
        //Then
        XCTAssertEqual(2, users.count)
        XCTAssertEqual("asd123", users[0].id)
        XCTAssertEqual("asd321", users[1].id)
    }
    
    func test_UserService_fetchUser_userExists() async throws {
        //Given
        let userService = MockUserService()
        
        //When
        let user = await userService.fetchUser(id: "asd123")
        
        //Then
        XCTAssertNotNil(user)
        XCTAssertEqual("asd123", user?.id)
    }
    
    func test_UserService_fetchUser_userNotExists() async throws {
        //Given
        let userService = MockUserService()
        
        //When
        let user = await userService.fetchUser(id: "asd")
        
        //Then
        XCTAssertNil(user)
    }
    
    func test_UserService_createUser() async throws {
        //Given
        let userService = MockUserService()
        let newUser = User(id: "asd111", username: "Bob", email: "bobby@gmail.com", country: "Nepal", imageUrl: "https://profile_image")
        
        //When
        try await userService.createUser(user: newUser)
        let users = await userService.fetchAllUser()
        
        //Then
        XCTAssertEqual(3, users.count)
    }
}
