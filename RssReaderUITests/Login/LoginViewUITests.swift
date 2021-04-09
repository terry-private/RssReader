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
        let alert = DummyLoginAlert()
        XCTAssert(loginViewPage.exists) // test002
        #if DebugDummy
            XCTAssertFalse(loginViewPage.lineLoginButton.exists)  // test009
            XCTAssertFalse(loginViewPage.mailLoginButton.exists)  // test010
            XCTAssertTrue(loginViewPage.dummyLoginButton.exists)  // test011
            
            // ログインアラートのテスト
            loginViewPage.dummyLoginButton.tap()
        
            // test012　アラート表示成功
            XCTAssertTrue(alert.exists)
        
            // test013　キャンセルボタンでアラートを閉じるのが成功
            XCTAssert(alert.cancelButton.exists)
            XCTAssert(alert.loginButton.exists)
            alert.cancelButton.tap()
            XCTAssertFalse(alert.exists)
        
            // test 014
            // 空文字でログインボタンを押すとアラート閉じるのが成功
            loginViewPage.dummyLoginButton.tap()
            alert.loginButton.tap()
            XCTAssertFalse(alert.exists)
            
            // test 016
            // 「8文字以上12文字以下ではない」の文字列を入力後
            // エラーアラートが表示（ログインIDは8〜12文字です。）
            loginViewPage.dummyLoginButton.tap()
            alert.loginIdTextField.tap()
            alert.loginIdTextField.typeText("1234567")
            alert.loginButton.tap()
            XCTAssertTrue(alert.errorAlert.staticTexts["ログインIDは8〜12文字です。"].exists)
        
            // test 018　エラーアラートのOKボタンでエラーアラートが閉じる
            alert.tappedErrorAlertOKButton()
            XCTAssertFalse(alert.errorAlert.exists)
            
        // test 017
        // 「8文字以上12文字以下」かつ「英数字以外を含む」の文字列を入力後
        // ログインボタンを押すとアラート閉じて
        // エラーアラートが表示（ログインIDは英数字のみです。）
        loginViewPage.dummyLoginButton.tap()
        alert.loginIdTextField.tap()
        alert.loginIdTextField.typeText("1234567!")
        alert.loginButton.tap()
        XCTAssertTrue(alert.errorAlert.staticTexts["ログインIDは英数字のみです。"].exists)
        
        // test 018
        // 「8文字以上12文字以下」かつ「英数字のみ」の文字列を入力後
        // ログインボタンを押すとアラート閉じる
        loginViewPage.dummyLoginButton.tap()
        alert.loginIdTextField.tap()
        alert.loginIdTextField.typeText("12345678")
        alert.loginButton.tap()
        XCTAssertFalse(loginViewPage.exists)


        #else
            XCTAssertTrue(loginViewPage.lineLoginButton.exists)   // test003
            XCTAssertTrue(loginViewPage.mailLoginButton.exists)   // test004
            XCTAssertFalse(loginViewPage.dummyLoginButton.exists) // test005
        #endif
    }

}
