//
//  SettingUITests.swift
//  RssReaderUITests
//
//  Created by 若江照仁 on 2021/04/19.
//

import XCTest

class SettingUITests: XCTestCase {
    let app = XCUIApplication()
    let settingPage = SettingViewPage()
    let accountPage = AccountPropertyViewPage()
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments.append("-isUITest")
        app.launch()
    }

    func testAfterLogin() throws {
        MainTabBar().settingBar.tap()
        accountPageTest()
    }
    
    private func accountPageTest() {
        // test 235
        // アカウント情報画面への遷移確認
        XCTContext.runActivity(named: "test 235") { _ in
            settingPage.accountCell.tap()
            XCTAssertTrue(accountPage.exists)
        }
        
        // test 258
        // 閉じるボタンの動作確認
        XCTContext.runActivity(named: "test 258") { _ in
            accountPage.closeButton.tap()
            XCTAssertFalse(accountPage.exists)
        }
        
        // test 265
        // 画像選択画面への遷移
        XCTContext.runActivity(named: "test 265") { _ in
            settingPage.toAccountProperty().profileImageButton.tap()
            XCTAssert(accountPage.imagePickerView.waitForExistence(timeout: 1))
        }
        
        // 画像を選択する挙動
        accountPage.imagePickerView.images.element(boundBy: 1).forceTap()
        sleep(1) // ラグによる操作ミスを回避します。
        if app.buttons["Choose"].exists {
            app.buttons["Choose"].tap()
        } else {
            app.buttons["選択"].tap()
        }
        
        // test268
        // バリデーションNGの確認
        XCTContext.runActivity(named: "test 268") { _ in
            accountPage.usernameTextField.clearAndEnterText(text: "")
            accountPage.view.tap()
            XCTAssertFalse(accountPage.confirmButton.isEnabled)
        }
        
        // test267
        // バリデーションOKの確認
        XCTContext.runActivity(named: "test 267") { _ in
            accountPage.usernameTextField.clearAndEnterText(text: "テスト2")
            accountPage.view.tap()
            XCTAssertTrue(accountPage.confirmButton.isEnabled)
        }
        
        // test269
        // アカウント名がテスト２に変更されていることを確認
        XCTContext.runActivity(named: "test 269") { _ in
            accountPage.confirmButton.tap()
            XCTAssertTrue(settingPage.exists)
            XCTAssertEqual(settingPage.accountNameLabel.label,"テスト2")
        }
        
        // test 270
        // ログアウトボタンの動作確認
        XCTContext.runActivity(named: "test 270") { _ in
            settingPage.accountCell.tap()
            XCTAssertTrue(accountPage.exists)
            accountPage.logoutButton.tap()
            XCTAssertTrue(LoginViewPage().exists)
        }
        
        // メールアカウントでのログイン状態に戻します。
        LoginViewPage().loginDummyMailAccount()
    }
    
    private func rssFeedCellTest() {
        
    }
}
