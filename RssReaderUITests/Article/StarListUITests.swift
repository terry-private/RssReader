//
//  StarListUITests.swift
//  RssReaderUITests
//
//  Created by 若江照仁 on 2021/04/21.
//

import XCTest

class StarListUITests: XCTestCase {
    let app = XCUIApplication()
    let starListPage = StarListViewPage()
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments.append("-isUITest")
        app.launch()
    }

    // お気に入りの記事が一件以上ある状態でテストしてください。
    func testAfterLogin() throws {
        MainTabBar().starListBar.tap()
        // コレクションビューのテスト
        collectionViewCellTest()
        
        // tableViewへの切り替え動作
        MainTabBar().settingBar.tap()
        SettingViewPage().displayModeSegmentedControl.buttons.firstMatch.tap()
        MainTabBar().starListBar.tap()
        
        // テーブルのテスト
        tableCellTest()
    }
    // MARK:- コレクションビューのテスト
    private func collectionViewCellTest() {
        // test 216
        // 記事セルロングタップの動作確認
        XCTContext.runActivity(named: "test 216") { _ in
            starListPage.collectionViewFirstCell.view.press(forDuration: 1)
            XCTAssertTrue(starListPage.collectionViewFirstCell.isOpenContextMenu)
        }
        
        // test 224
        // 任意の箇所をタップでコンテクストメニューが閉じるかどうか
        XCTContext.runActivity(named: "test 224") { _ in
            app.tap()
            XCTAssertFalse(starListPage.collectionViewFirstCell.isOpenContextMenu)
        }
        
        // test 225
        // お気に入り解除ボタンの動作確認
        XCTContext.runActivity(named: "test 225") { _ in
            let firstCellArticleTitle = starListPage.collectionViewFirstCell.articleTitleLabel.label
            starListPage.collectionViewFirstCell.view.press(forDuration: 1)
            starListPage.collectionViewFirstCell.unStarButton.tap()
            XCTAssertNotEqual(starListPage.collectionViewFirstCell.articleTitleLabel.label, firstCellArticleTitle)
        }
        
        
        // test 227 228
        // 条件によってtestの順番が入れ替わるので関数を定義しておきます。
        func test227() {
            // 未読にするボタンの動作確認
            XCTContext.runActivity(named: "test 227") { _ in
                starListPage.collectionViewFirstCell.view.press(forDuration: 1)
                starListPage.collectionViewFirstCell.unReadButton.tap()
                XCTAssertFalse(starListPage.collectionViewFirstCell.isRead)
            }
        }
        func test228() {
            // 既読にするボタンの動作確認
            XCTContext.runActivity(named: "test 228") { _ in
                starListPage.collectionViewFirstCell.view.press(forDuration: 1)
                starListPage.collectionViewFirstCell.readButton.tap()
                XCTAssertTrue(starListPage.collectionViewFirstCell.isRead)
            }
        }
        if starListPage.collectionViewFirstCell.isRead {
            // 今が既読なら未読にしてから既読に戻す流れでテストします。
            test227()
            test228()
        } else {
            test228()
            test227()
        }
        
        
        // test 229 230
        // 条件によってtestの順番が入れ替わるので関数を定義しておきます。
        func test229() {
            // 後で読むを解除するボタンの動作確認
            XCTContext.runActivity(named: "test 229") { _ in
                starListPage.collectionViewFirstCell.view.press(forDuration: 1)
                starListPage.collectionViewFirstCell.unLaterReadButton.tap()
                // isLaterReadはコンテクストメニューが表示されている時のみ作動するので開き直します。
                starListPage.collectionViewFirstCell.view.press(forDuration: 1)
                XCTAssertFalse(starListPage.collectionViewFirstCell.isLaterRead)
                app.tap()
            }
        }
        func test230() {
            // 後で読むボタンの動作確認
            XCTContext.runActivity(named: "test 230") { _ in
                starListPage.collectionViewFirstCell.view.press(forDuration: 1)
                starListPage.collectionViewFirstCell.laterReadButton.tap()
                // isLaterReadはコンテクストメニューが表示されている時のみ作動するので開き直します。
                starListPage.collectionViewFirstCell.view.press(forDuration: 1)
                XCTAssertTrue(starListPage.collectionViewFirstCell.isLaterRead)
                app.tap()
            }
        }
        
        // isLaterReadはコンテクストメニューが表示されている時のみ作動するので開いておきます。
        starListPage.collectionViewFirstCell.view.press(forDuration: 1)
        if starListPage.collectionViewFirstCell.isLaterRead {
            app.tap()
            // 後で読む記事の場合　解除してから後で読むに戻す流れでテストします。
            test229()
            test230()
        } else {
            app.tap()
            test230()
            test229()
        }
    }
    // MARK:- テーブルのテスト
    private func tableCellTest() {
    }

}
