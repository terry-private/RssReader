//
//  ArticleListUITests.swift
//  RssReaderUITests
//
//  Created by 若江照仁 on 2021/04/15.
//

import XCTest

class ArticleListUITests: XCTestCase {
    let app = XCUIApplication()
    let articleListPage = ArticleListViewPage()
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments.append("-isUITest")
        app.launch()
    }

    func testAfterLogin() throws {
        // コレクションビューのテスト
        collectionViewCellTest()
        
        // tableViewへ切り替える動作
        MainTabBar().settingBar.tap()
        app.tables.cells.element(boundBy: 2).segmentedControls.buttons.firstMatch.tap()
        MainTabBar().articleListBar.tap()
        
        // テーブルのテスト
        tableCellTest()
    }
    
    // MARK:- テーブルのテスト
    private func tableCellTest() {
        // test 105
        // 右スワイプでスターボタンと後で読むボタンが表示
        XCTContext.runActivity(named: "test 105") { _ in
            articleListPage.tableFirstCell.view.swipeRight()
            XCTAssertTrue(articleListPage.tableFirstCell.starButton.exists)
            XCTAssertTrue(articleListPage.tableFirstCell.laterReadButton.exists)
        }
        
        // test 110 111
        // 右スワイプでスターボタンと後で読むボタンが表示
        XCTContext.runActivity(named: "test 110 111") { _ in
            if articleListPage.tableFirstCell.isStar {
                // お気に入りなら test 110
                // まずお気に入りが外せるかどうか
                articleListPage.tableFirstCell.starButton.tap()
                XCTAssertFalse(articleListPage.tableFirstCell.isStar)
                
                // お気に入りにし直せるかどうか test 111
                articleListPage.tableFirstCell.view.swipeRight()
                articleListPage.tableFirstCell.starButton.tap()
                XCTAssertTrue(articleListPage.tableFirstCell.isStar)
            } else {
                // お気に入りじゃないなら test 111
                // まずお気に入りにできるかどうか
                articleListPage.tableFirstCell.starButton.tap()
                XCTAssertTrue(articleListPage.tableFirstCell.isStar)
                
                // お気に入りを外せるかどうか test 110
                articleListPage.tableFirstCell.view.swipeRight()
                articleListPage.tableFirstCell.starButton.tap()
                XCTAssertFalse(articleListPage.tableFirstCell.isStar)
            }
        }
        
        // test 106 107 113 114
        // 最初が未読かどうかで処理の順番変えてます。
        XCTContext.runActivity(named: "test 106 107 113 114") { _ in
            if !articleListPage.tableFirstCell.isRead {
                t106_113()
                t107_114()
            } else {
                t107_114()
                t106_113()
            }
        }
        
        // test 112
        XCTContext.runActivity(named: "test 112") { _ in
            // 最初のセルの記事のタイトルを取得しておきます。
            let firstCellArticleTitle = articleListPage.tableFirstCell.articleTitleLabel.label
            
            articleListPage.tableFirstCell.view.swipeRight()
            articleListPage.tableFirstCell.laterReadButton.tap()
            
            // 最初のセルの記事タイトルと今のトップセルのタイトルは一致しなければOK
            XCTAssertNotEqual(articleListPage.tableFirstCell.articleTitleLabel.label, firstCellArticleTitle)
        }
        
    }
    
    private func t106_113() {
        XCTContext.runActivity(named: "test 106") { _ in
            articleListPage.tableFirstCell.view.swipeLeft()
            XCTAssertTrue(articleListPage.tableFirstCell.readButton.exists)
        }
        
        XCTContext.runActivity(named: "test 113") { _ in
            articleListPage.tableFirstCell.readButton.tap()
            XCTAssertTrue(articleListPage.tableFirstCell.isRead)
        }
    }
    
    private func t107_114() {
        XCTContext.runActivity(named: "test 107") { _ in
            articleListPage.tableFirstCell.view.swipeLeft()
            XCTAssertTrue(articleListPage.tableFirstCell.unReadButton.exists)
        }
        
        XCTContext.runActivity(named: "test 114") { _ in
            articleListPage.tableFirstCell.unReadButton.tap()
            XCTAssertFalse(articleListPage.tableFirstCell.isRead)
        }
    }
    
    // MARK:- コレクションビューのテスト
    private func collectionViewCellTest() {
        articleListPage.collectionViewFirstCell.view.press(forDuration: 1)
        
        // test 125
        XCTContext.runActivity(named: "test 125") { _ in
            XCTAssertTrue(articleListPage.collectionViewFirstCell.isOpenContextMenu)
        }
        
        // test 132
        XCTContext.runActivity(named: "test 132") { _ in
            app.tap()
            XCTAssertFalse(articleListPage.collectionViewFirstCell.isOpenContextMenu)
        }
        
        // test 133 134
        // 条件によってtestの順番が入れ替わるので関数を定義しておきます。
        func test133() {
            // お気に入り解除ができるかどうか
            XCTContext.runActivity(named: "test 133") { _ in
                articleListPage.collectionViewFirstCell.view.press(forDuration: 1)
                articleListPage.collectionViewFirstCell.unStarButton.tap()
                XCTAssertFalse(articleListPage.collectionViewFirstCell.isStar)
            }
        }
        
        func test134() {
            // お気に入りにできるかどうか
            XCTContext.runActivity(named: "test 134") { _ in
                articleListPage.collectionViewFirstCell.view.press(forDuration: 1)
            articleListPage.collectionViewFirstCell.starButton.tap()
            XCTAssertTrue(articleListPage.collectionViewFirstCell.isStar)
            }
        }
        
        if articleListPage.collectionViewFirstCell.isStar {
            // 今「お気に入り」なら解除してから「お気に入り」に戻す流れでテストします。
            test133()
            test134()
        } else {
            // 今「お気に入り」じゃないなら「お気に入り」にしてから解除する流れでテストします。
            test134()
            test133()
        }
        
        // test 135 136
        func test135() {
            // 未読にできるかどうか
            XCTContext.runActivity(named: "test 135") { _ in
                articleListPage.collectionViewFirstCell.view.press(forDuration: 1)
                articleListPage.collectionViewFirstCell.unReadButton.tap()
                XCTAssertFalse(articleListPage.collectionViewFirstCell.isRead)
            }
        }
        
        func test136() {
            // 既読にできるかどうか
            XCTContext.runActivity(named: "test 136") { _ in
                articleListPage.collectionViewFirstCell.view.press(forDuration: 1)
                articleListPage.collectionViewFirstCell.readButton.tap()
                XCTAssertTrue(articleListPage.collectionViewFirstCell.isRead)
            }
        }
        
        if articleListPage.collectionViewFirstCell.isRead {
            // 今が既読なら未読にしてから既読に戻す流れでテストします。
            test135()
            test136()
        } else {
            // 今が未読なら既読にしてから未読に戻す流れでテストします。
            test136()
            test135()
        }
        
        // test 137
        XCTContext.runActivity(named: "test 137") { _ in
            let firstCellArticleTitle = articleListPage.collectionViewFirstCell.articleTitleLabel.label
            articleListPage.collectionViewFirstCell.view.press(forDuration: 1)
            articleListPage.collectionViewFirstCell.laterReadButton.tap()
            XCTAssertNotEqual(articleListPage.collectionViewFirstCell.articleTitleLabel.label, firstCellArticleTitle)
        }
    }
    
}

class ArticleListAnimationUITests: XCTestCase {
    let app = XCUIApplication()
    let articleListPage = ArticleListViewPage()
    let mainTabBar = MainTabBar()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAfterLogin() throws {
        // test 091
        XCTAssertTrue(app.activityIndicators.firstMatch.exists)
        
        var listView: XCUIElement!
        
        if articleListPage.table.exists {
            XCTAssertTrue(articleListPage.table.cells.element.waitForExistence(timeout: 3))
            listView = articleListPage.table
            
        } else {
            XCTAssertTrue(articleListPage.collectionView.cells.element.waitForExistence(timeout: 3))
            listView = articleListPage.collectionView
        }
        
        listView.cells.firstMatch.press(forDuration: 0.1, thenDragTo: mainTabBar.bar, withVelocity: 300, thenHoldForDuration: 1)
//        XCTAssertTrue(app.activityIndicators.firstMatch.exists)
    }
}
