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
    
    // MARK:- DebugDummyビルド時のテストです。
    func testDummyBuild() throws {
        #if !DebugDummy
            return
        #endif
        
        LoginViewPage().dummySetUp()
        MainTabBar().settingBar.tap()
        
        // test 237
        XCTContext.runActivity(named: "test 237") { _ in
            settingPage.accountCell.tap()
            XCTAssertTrue(LoginViewPage().exists)
        }
    }
    
    // MARK:- LINEログインしている状態でのテストです。
    func testAfterLineLogin() throws {
        #if DebugDummy || DebugNonSecure
            return
        #endif
        
        MainTabBar().settingBar.tap()
        
        // test 236
        // LINEログアウトのアラート表示
        XCTContext.runActivity(named: "test 236") { _ in
            settingPage.accountCell.tap()
            XCTAssertTrue(settingPage.alert.exists)
        }
        
        // test 249
        // LINEログアウトアラートのキャンセルボタンの動作確認
        XCTContext.runActivity(named: "test 249") { _ in
            settingPage.alertCancelButton.tap()
            XCTAssertFalse(settingPage.alert.exists)
        }
        
        #if DebugSecure || DebugNonSecure
            // test 252
            // Releaseビルド以外で「トークンの更新」ボタンが表示
            XCTContext.runActivity(named: "test 252") { _ in
                settingPage.accountCell.tap()
                XCTAssertTrue(settingPage.alertRefreshButton.exists)
            }
            
            // test 253
            // Releaseビルド以外で「トークンの更新」ボタンの動作確認
            XCTContext.runActivity(named: "test 253") { _ in
                settingPage.alertRefreshButton.tap()
                XCTAssertFalse(settingPage.alert.exists)
            }
            // alertを開き直しておきます。
            settingPage.accountCell.tap()
        #else
            // test 251
            // Releaseビルドで「トークンの更新」ボタンが非表示
            XCTContext.runActivity(named: "test 251") { _ in
                XCTAssertFalse(settingPage.alertRefreshButton.exists)
            }
        #endif
        
        // test 250
        // LINEログアウトボタンの動作確認
        XCTContext.runActivity(named: "test 250") { _ in
            settingPage.alertLogoutButton.tap()
            XCTAssertTrue(LoginViewPage().exists)
        }
    }

    // MARK:- メールアカウントでのログイン状態でのテスト
    func testAfterMailLogin() throws {
        MainTabBar().settingBar.tap()
        accountPageTest()
        rssFeedCellTest()
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
            app.returnKey.tap()
            XCTAssertFalse(accountPage.confirmButton.isEnabled)
        }
        
        // test267
        // バリデーションOKの確認
        XCTContext.runActivity(named: "test 267") { _ in
            accountPage.usernameTextField.clearAndEnterText(text: "テスト2")
            app.returnKey.tap()
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
        
        // test 245
        // 左スワイプでDeleteボタンが出現
        XCTContext.runActivity(named: "test 245") { _ in
            settingPage.rssFeedFirstCell.swipeLeft()
            XCTAssertTrue(settingPage.firstCellSwipeDeleteButton.exists)
        }
        
        // test 247
        // Deleteボタン動作確認
        XCTContext.runActivity(named: "test 247") { _ in
            let rssFeedCount = settingPage.rssFeedCount
            settingPage.firstCellSwipeDeleteButton.tap()
            XCTAssertEqual(settingPage.rssFeedCount, rssFeedCount - 1)
        }
        
        // test 248
        // AddRssFeedButtonの動作確認
        XCTContext.runActivity(named: "test 248") { _ in
            settingPage.addRssFeedCell.tap()
            XCTAssertTrue(SelectRssFeedTypeViewPage().exists)
        }
        
        //　後処理
        // RssFeed追加画面を一旦閉じて、Qiitaの「iOS」タグの記事を追加して終了
        SelectRssFeedTypeViewPage().cancelButton.tap()
        settingPage.addNewQiita("iOS")
    }
}
