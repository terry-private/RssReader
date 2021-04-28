//
//  LaterReadListUITests.swift
//  RssReaderUITests
//
//  Created by 若江照仁 on 2021/04/21.
//

import XCTest

class LaterReadListUITests: XCTestCase {
    let app = XCUIApplication()
    let laterReadPage = LaterReadListViewPage()
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments.append("-isUITest")
        app.launch()
    }

    // 後で読む記事が一件以上ある状態でテストしてください。
    func testAfterLogin() throws {
        MainTabBar().laterReadBar.tap()
        // コレクションビューのテスト
        collectionViewCellTest()
        
        // tableViewへの切り替え動作
        MainTabBar().settingBar.tap()
        SettingViewPage().displayModeSegmentedControl.buttons.firstMatch.tap()
        MainTabBar().laterReadBar.tap()
        
        // テーブルのテスト
        tableCellTest()
    }
    // MARK:- コレクションビューのテスト
    private func collectionViewCellTest() {
        // test 171
        // 記事セルロングタップの動作確認
        XCTContext.runActivity(named: "test 171") { _ in
            laterReadPage.collectionViewFirstCell.view.press(forDuration: 1)
            XCTAssertTrue(laterReadPage.collectionViewFirstCell.isOpenContextMenu)
        }
        
        // test 178
        // 任意の箇所をタップでコンテクストメニューが閉じるかどうか
        XCTContext.runActivity(named: "test 178") { _ in
            app.tap()
            XCTAssertFalse(laterReadPage.collectionViewFirstCell.isOpenContextMenu)
        }
        
        // test 179 180
        // 条件によってtestの順番が入れ替わるので関数を定義しておきます。
        func test179() {
            // お気に入り解除ボタンの動作確認
            XCTContext.runActivity(named: "test 179") { _ in
                laterReadPage.collectionViewFirstCell.view.press(forDuration: 1)
                laterReadPage.collectionViewFirstCell.unStarButton.tap()
                XCTAssertFalse(laterReadPage.collectionViewFirstCell.isStar)
            }
        }
        func test180() {
            // お気に入りボタンの動作確認
            XCTContext.runActivity(named: "test 180") { _ in
                laterReadPage.collectionViewFirstCell.view.press(forDuration: 1)
                laterReadPage.collectionViewFirstCell.starButton.tap()
                XCTAssertTrue(laterReadPage.collectionViewFirstCell.isStar)
            }
        }
        
        if laterReadPage.collectionViewFirstCell.isStar {
            // 今「お気に入り」なら解除してから「お気に入り」に戻す流れでテストします。
            test179()
            test180()
        } else {
            test180()
            test179()
        }
        
        // test 181 182
        // 条件によってtestの順番が入れ替わるので関数を定義しておきます。
        func test181() {
            // 未読にするボタンの動作確認
            XCTContext.runActivity(named: "test 181") { _ in
                laterReadPage.collectionViewFirstCell.view.press(forDuration: 1)
                laterReadPage.collectionViewFirstCell.unReadButton.tap()
                XCTAssertFalse(laterReadPage.collectionViewFirstCell.isRead)
            }
        }
        func test182() {
            // 既読にするボタンの動作確認
            XCTContext.runActivity(named: "test 182") { _ in
                laterReadPage.collectionViewFirstCell.view.press(forDuration: 1)
                laterReadPage.collectionViewFirstCell.readButton.tap()
                XCTAssertTrue(laterReadPage.collectionViewFirstCell.isRead)
            }
        }
        
        if laterReadPage.collectionViewFirstCell.isRead {
            // 今が既読なら未読にしてから既読に戻す流れでテストします。
            test181()
            test182()
        } else {
            test182()
            test181()
        }
        
        // test 183
        // 後で読むを解除するボタンの動作確認
        XCTContext.runActivity(named: "test 183") { _ in
            let firstCellArticleTitle = laterReadPage.collectionViewFirstCell.articleTitleLabel.label
            laterReadPage.collectionViewFirstCell.view.press(forDuration: 1)
            laterReadPage.collectionViewFirstCell.unLaterReadButton.tap()
            XCTAssertNotEqual(laterReadPage.collectionViewFirstCell.articleTitleLabel.label, firstCellArticleTitle)
        }
    }
    // MARK:- テーブルのテスト
    private func tableCellTest() {
        
        // test 151
        // 記事セル右スワイプの動作確認
        XCTContext.runActivity(named: "test 151") { _ in
            laterReadPage.tableFirstCell.view.swipeRight()
            XCTAssertTrue(laterReadPage.tableFirstCell.starButton.exists)
            XCTAssertTrue(laterReadPage.tableFirstCell.laterReadButton.exists)
            laterReadPage.tableFirstCell.view.tap()
        }
        
        // test 152 153 159 160
        // 条件によってtestの順番が入れ替わるので関数を定義しておきます。
        func test152() {
            // 記事セル左スワイプ（未読時）の動作確認
            XCTContext.runActivity(named: "test 152") { _ in
                laterReadPage.tableFirstCell.view.swipeLeft()
                XCTAssertTrue(laterReadPage.tableFirstCell.readButton.exists)
            }
        }
        func test153() {
            // 記事セル左スワイプ（既読時）の動作確認
            XCTContext.runActivity(named: "test 153") { _ in
                laterReadPage.tableFirstCell.view.swipeLeft()
                XCTAssertTrue(laterReadPage.tableFirstCell.unReadButton.exists)
            }
        }
        func test159() {
            // チェックボタンの動作確認
            XCTContext.runActivity(named: "test 159") { _ in
                laterReadPage.tableFirstCell.readButton.tap()
                XCTAssertTrue(laterReadPage.tableFirstCell.isRead)
            }
        }
        func test160() {
            // 未読にするボタンの動作確認
            XCTContext.runActivity(named: "test 160") { _ in
                laterReadPage.tableFirstCell.unReadButton.tap()
                XCTAssertFalse(laterReadPage.tableFirstCell.isRead)
            }
        }
        
        if laterReadPage.tableFirstCell.isRead {
            // 既読の場合
            test153()   // 未読にするボタンが出てくる
            test160()   // 押すと未読になる
            test152()   // チェックボタンが出てくる
            test159()   // 押すと既読になる
        } else {
            // 未読の場合
            test152()   // チェックボタンが出てくる
            test159()   // 押すと既読になる
            test153()   // 未読にするボタンが出てくる
            test160()   // 押すと未読になる
        }
        
        
        // test 156 157
        // 条件によってtestの順番が入れ替わるので関数を定義しておきます。
        func test156() {
            // スターボタン（お気に入り時）の動作確認
            XCTContext.runActivity(named: "test 156") { _ in
                laterReadPage.tableFirstCell.view.swipeRight()
                laterReadPage.tableFirstCell.starButton.tap()
                XCTAssertFalse(laterReadPage.tableFirstCell.isStar)
            }
        }
        func test157() {
            // スターボタン（お気に入りでなはい時）の動作確認
            XCTContext.runActivity(named: "test 157") { _ in
                laterReadPage.tableFirstCell.view.swipeRight()
                laterReadPage.tableFirstCell.starButton.tap()
                XCTAssertTrue(laterReadPage.tableFirstCell.isStar)
            }
        }
        
        if laterReadPage.tableFirstCell.isStar {
            // お気に入りの場合
            test156()
            test157()
        } else {
            // お気に入りでは無い場合
            test157()
            test156()
        }
        
        // test 158
        // 後で読むボタンの動作確認
        XCTContext.runActivity(named: "test 158") { _ in
            let firstCellArticleTitle = laterReadPage.tableFirstCell.articleTitleLabel.label
            laterReadPage.tableFirstCell.view.swipeRight()
            laterReadPage.tableFirstCell.laterReadButton.tap()
            XCTAssertNotEqual(laterReadPage.tableFirstCell.articleTitleLabel.label, firstCellArticleTitle)
        }
    }
}
