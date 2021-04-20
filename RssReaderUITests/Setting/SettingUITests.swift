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
        XCTContext.runActivity(named: "test 235") { _ in
            settingPage.accountCell.tap()
            XCTAssertTrue(accountPage.exists)
        }
        
        // test 258
        XCTContext.runActivity(named: "test 258") { _ in
            accountPage.closeButton.tap()
            XCTAssertFalse(accountPage.exists)
        }
        
        // test 265
        XCTContext.runActivity(named: "test 265") { _ in
            settingPage.toAccountProperty().profileImageButton.tap()
            XCTAssert(accountPage.imagePickerView.waitForExistence(timeout: 1))
        }
        
        accountPage.imagePickerView.images.element(boundBy: 1).forceTap()
        sleep(1) // ラグによる操作ミスを回避します。
        if app.buttons["Choose"].exists {
            app.buttons["Choose"].tap()
        } else {
            app.buttons["選択"].tap()
        }
        
        // test268
        accountPage.usernameTextField.clearAndEnterText(text: "")
        accountPage.view.tap()
        XCTAssertFalse(accountPage.confirmButton.isEnabled)
        
        // test267
        accountPage.usernameTextField.clearAndEnterText(text: "テスト2")
        accountPage.view.tap()
        XCTAssertTrue(accountPage.confirmButton.isEnabled)
        
        // test269
        accountPage.confirmButton.tap()
        XCTAssertTrue(settingPage.exists)
        XCTAssertEqual(settingPage.accountNameLabel.label,"テスト2")
        
    }
}
