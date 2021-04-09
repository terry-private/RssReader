//
//  LoginViewUITests.swift
//  RssReaderUITests
//
//  Created by 若江照仁 on 2021/04/08.
//

import XCTest

class LoginViewUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testオートログイン失敗_002_003_004_005_009_010_011() throws {
        let loginViewPage = LoginViewPage()
        XCTAssert(loginViewPage.exists) // test002
        #if DebugDummy
            XCTAssertFalse(loginViewPage.lineLoginButton.exists)  // test009
            XCTAssertFalse(loginViewPage.mailLoginButton.exists)  // test010
            XCTAssertTrue(loginViewPage.dummyLoginButton.exists)  // test011
        
        loginViewPage.dummyLoginButton.tap()
        let alert = DummyLoginAlert()
        XCTAssertTrue(alert.exists)
        XCTAssert(alert.cancelButton.exists)
        XCTAssert(alert.loginButton.exists)
        alert.cancelButton.tap()
        XCTAssertFalse(alert.exists)
        
        loginViewPage.dummyLoginButton.tap()
        alert.loginButton.tap()
        XCTAssertFalse(alert.exists)
        
        #else
            XCTAssertTrue(loginViewPage.lineLoginButton.exists)   // test003
            XCTAssertTrue(loginViewPage.mailLoginButton.exists)   // test004
            XCTAssertFalse(loginViewPage.dummyLoginButton.exists) // test005
        #endif
    }

}
