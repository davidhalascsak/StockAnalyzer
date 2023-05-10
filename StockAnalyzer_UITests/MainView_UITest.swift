import XCTest

final class MainView_UITest: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_MainView_TabVIew_exists() throws {
        let app = XCUIApplication()
        let tabBar = app.tabBars["Tab Bar"]
        let home = tabBar.buttons["Home"]
        let news = tabBar.buttons["newspaper"]
        let portfolio = tabBar.buttons["Briefcase"]
        let search = tabBar.buttons["Search"]
        
        XCTAssertTrue(tabBar.exists)
        XCTAssertTrue(home.exists)
        XCTAssertTrue(news.exists)
        XCTAssertTrue(portfolio.exists)
        XCTAssertTrue(search.exists)
    }
}
