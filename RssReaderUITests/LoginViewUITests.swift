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

    func test003_009_LINEログインボタンの表示() throws {
        let lineLoginButton = app.buttons["line_login_button"]
        #if DebugDummy
            XCTAssertFalse(lineLoginButton.exists)
        #else
            XCTAssertTrue(lineLoginButton.exists)
        #endif
    }
    
    func test004_010_メールログインボタンの表示() throws {
        let mailLoginButton = app.buttons["mail_login_button"]
        #if DebugDummy
            XCTAssertFalse(mailLoginButton.exists)
        #else
            XCTAssertTrue(mailLoginButton.exists)
        #endif
    }
    
    func test005_011_ログインIDを入力ボタンの表示() throws {
        let dummyLoginButton = app.buttons["dummy_login_button"]
        #if DebugDummy
            XCTAssertTrue(dummyLoginButton.exists)
        #else
            XCTAssertFalse(dummyLoginButton.exists)
        #endif
    }
    
    

}
