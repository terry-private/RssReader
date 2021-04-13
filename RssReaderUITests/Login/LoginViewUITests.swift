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
        
        // test 015
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
        loginViewPage.mailLoginButton.tap()
        mailLoginUITest()
        #endif
    }
    
    // MARK:- mailLoginUITest
    // ○: 008 019~021 024~032 036
    // △: 019 033 034
    // ✖︎: 022 023 035
    private func mailLoginUITest() {
        let loginViewPage = LoginViewPage()
        let mailLoginViewPage = MailLoginViewPage()
        XCTAssertTrue(mailLoginViewPage.exists)                         // test008
        XCTAssertFalse(mailLoginViewPage.mailLoginButton.isEnabled)     // test019
        XCTAssertEqual(mailLoginViewPage.mailTextField.label, "")       // test020
        XCTAssertEqual(mailLoginViewPage.passwordTextField.label, "")   // test021
        XCTAssertTrue(mailLoginViewPage.backButton.exists)
        mailLoginViewPage.backButton.tap()
        
        XCTAssertTrue(loginViewPage.exists) // test024
        
        loginViewPage.mailLoginButton.tap()
        
        
        mailLoginViewPage.mailTextField.tap()
        XCTAssertTrue(returnKey.exists)     // test025 キーボードのリターンキーがあるかどうかでキーボードが開いたかどうかの確認をしています。
        app.staticTexts["メールアドレス"].tap()    // メールアドレスラベルをタップで任意の箇所タップを表現します。
        XCTAssertFalse(returnKey.exists) // test026
        
        mailLoginViewPage.mailTextField.tap()
        returnKey.tap()
        XCTAssertFalse(returnKey.exists) // test027
        
        mailLoginViewPage.mailTextField.tap()
        mailLoginViewPage.passwordTextField.tap()
        
        // test028
        // ・リターンキーが「Done」であること
        // ・空文字状態だとリターンキーが押せない状態
        // ↑でパスワード用のキーボードに変わったかどうかの判定
        XCTAssertEqual(returnKey.label, "done")
        XCTAssertFalse(returnKey.isEnabled)
        
        // test030
        // メールアドレスラベルをタップで任意の箇所タップを表現します。
        app.staticTexts["メールアドレス"].tap()
        XCTAssertFalse(returnKey.exists)
        
        // test029
        mailLoginViewPage.passwordTextField.tap()
        XCTAssertTrue(returnKey.exists)
        
        // test031
        // 空文字だとリターンキーが押せないので１を入力してテストします。
        mailLoginViewPage.passwordTextField.typeText("1")
        returnKey.tap()
        XCTAssertFalse(returnKey.exists)
        
        // test032
        // リターンキーが「完了」であることで標準キーボードに変わったかどうかの判定
        mailLoginViewPage.passwordTextField.tap()
        mailLoginViewPage.mailTextField.tap()
        XCTAssertEqual(returnKey.label, "完了")
        
        // test033
        mailLoginViewPage.mailTextField.tap()
        mailLoginViewPage.mailTextField.typeText("test@test.com")
        mailLoginViewPage.passwordTextField.tap()
        mailLoginViewPage.passwordTextField.typeText("123456")
        returnKey.tap()
        XCTAssertTrue(mailLoginViewPage.mailLoginButton.isEnabled)
        
        // test034　２種類試します。
            // メールアドレスの形式だけおかしい場合
        mailLoginViewPage.mailTextField.clearAndEnterText(text: "test@test")
        mailLoginViewPage.passwordTextField.tap()
        mailLoginViewPage.passwordTextField.typeText("123456")
        returnKey.tap()
        XCTAssertFalse(mailLoginViewPage.mailLoginButton.isEnabled)
        
            // パスワードだけおかしい場合
        mailLoginViewPage.mailTextField.clearAndEnterText(text: "test@test.com")
        mailLoginViewPage.passwordTextField.tap()
        mailLoginViewPage.passwordTextField.typeText("12345")
        returnKey.tap()
        XCTAssertFalse(mailLoginViewPage.mailLoginButton.isEnabled)
        
        // test 036　メールログインボタンで新規アカウント作成アラートへの遷移
        // 一旦正しいメールアドレスとパスワードにします。
        mailLoginViewPage.passwordTextField.tap()
        mailLoginViewPage.passwordTextField.typeText("123456")
        returnKey.tap()
        // ここからが手順
        mailLoginViewPage.mailLoginButton.tap()
        XCTAssertTrue(mailLoginViewPage.newAccountAlert.exists)
        
        // test 039 新規アカウント作成アラートのキャンセルボタンでアラートが閉じる
        mailLoginViewPage.alertCancelButton.tap()
        XCTAssertFalse(mailLoginViewPage.newAccountAlert.exists)
        
    }
    
    // 日本語のキーボードのみ対応することにします。
    private var returnKey: XCUIElement {
        if app.buttons["完了"].exists {
            return app.buttons["完了"]
        } else {
            return app.buttons["done"]
        }
    }

}


extension XCUIElement {
    /**
     Removes any current text in the field before typing in the new value
     - Parameter text: the text to enter into the field
     */
    func clearAndEnterText(text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }
        self.tap()
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        self.typeText(deleteString)
        self.typeText(text)
    }
}
