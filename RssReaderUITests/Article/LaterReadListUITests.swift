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

    func testAfterLogin() throws {
        MainTabBar().laterReadBar.tap()
        collectionViewCellTest()
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
}
