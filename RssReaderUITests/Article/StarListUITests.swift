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
        
        toTableView()
        
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
        
        // test 196
        // 記事セル右スワイプの動作確認
        XCTContext.runActivity(named: "test 196") { _ in
            starListPage.tableFirstCell.view.swipeRight()
            XCTAssertTrue(starListPage.tableFirstCell.starButton.exists)
            XCTAssertTrue(starListPage.tableFirstCell.laterReadButton.exists)
            starListPage.tableFirstCell.view.tap()
        }
        
        // test 197 198 204 205
        // 条件によってtestの順番が入れ替わるので関数を定義しておきます。
        func test197() {
            // 記事セル左スワイプ（未読時）の動作確認
            XCTContext.runActivity(named: "test 197") { _ in
                starListPage.tableFirstCell.view.swipeLeft()
                XCTAssertTrue(starListPage.tableFirstCell.readButton.exists)
            }
        }
        func test198() {
            // 記事セル左スワイプ（既読時）の動作確認
            XCTContext.runActivity(named: "test 198") { _ in
                starListPage.tableFirstCell.view.swipeLeft()
                XCTAssertTrue(starListPage.tableFirstCell.unReadButton.exists)
            }
        }
        func test204() {
            // チェックボタンの動作確認
            XCTContext.runActivity(named: "test 204") { _ in
                starListPage.tableFirstCell.readButton.tap()
                XCTAssertTrue(starListPage.tableFirstCell.isRead)
            }
        }
        func test205() {
            // 未読にするボタンの動作確認
            XCTContext.runActivity(named: "test 205") { _ in
                starListPage.tableFirstCell.unReadButton.tap()
                XCTAssertFalse(starListPage.tableFirstCell.isRead)
            }
        }
        
        if starListPage.tableFirstCell.isRead {
            // 既読の場合
            test198()   // 未読にするボタンが出てくる
            test205()   // 押すと未読になる
            test197()   // チェックボタンが出てくる
            test204()   // 押すと既読になる
        } else {
            // 未読の場合
            test197()   // チェックボタンが出てくる
            test204()   // 押すと既読になる
            test198()   // 未読にするボタンが出てくる
            test205()   // 押すと未読になる
        }
        
        // test 201
        // スターボタン（お気に入り時）の動作確認
        XCTContext.runActivity(named: "test 201") { _ in
            let firstCellArticleTitle = starListPage.tableFirstCell.articleTitleLabel.label
            starListPage.tableFirstCell.view.swipeRight()
            starListPage.tableFirstCell.starButton.tap()
            XCTAssertNotEqual(starListPage.tableFirstCell.articleTitleLabel.label, firstCellArticleTitle)
        }
        
        // test 202 203
        // 条件によってtestの順番が入れ替わるので関数を定義しておきます。
        func test202() {
            // 後で読むボタン（後で読む記事の場合）の動作確認
            XCTContext.runActivity(named: "test 202") { _ in
                starListPage.tableFirstCell.view.swipeRight()
                starListPage.tableFirstCell.laterReadButton.tap()
                XCTAssertFalse(isFirstTableCellLaterRead())
            }
        }
        func test203() {
            // 後で読むボタン（後で読む記事では無い場合）の動作確認
            XCTContext.runActivity(named: "test 203") { _ in
                starListPage.tableFirstCell.view.swipeRight()
                starListPage.tableFirstCell.laterReadButton.tap()
                XCTAssertTrue(isFirstTableCellLaterRead())
            }
        }
        
        if isFirstTableCellLaterRead() {
            test202()
            test203()
        } else {
            test203()
            test202()
        }
    }
    
    // tableViewへの切り替え動作
    func toTableView() {
        MainTabBar().settingBar.tap()
        SettingViewPage().displayModeSegmentedControl.buttons["line.horizontal.3.decrease"].tap()
        MainTabBar().starListBar.tap()
    }
    
    // collectionViewへの切り替え動作
    func toCollectionView() {
        MainTabBar().settingBar.tap()
        SettingViewPage().displayModeSegmentedControl.buttons["grid 2x2"].tap()
        MainTabBar().starListBar.tap()
    }
    
    // isLaterReadはコレクションビューのコンテクストメニューが表示されている時のみ作動するので、
    // 一旦設定画面でディスプレイモードをコレクションビューの表示に変更して
    // 対象セルのコンテクストメニューを開いて、isLaterReadを拾ってまたテーブルビューの表示に戻します。
    func isFirstTableCellLaterRead() -> Bool{
        toCollectionView()
        starListPage.collectionViewFirstCell.view.press(forDuration: 1)
        let isLaterRead = starListPage.collectionViewFirstCell.isLaterRead
        app.tap()
        toTableView()
        return isLaterRead
    }
}
