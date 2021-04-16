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
        MainTabBar().settingBar.tap()
        app.tables.cells.element(boundBy: 2).segmentedControls.buttons.firstMatch.tap()
        MainTabBar().articleListBar.tap()
        // test 0``
        if articleListPage.table.waitForExistence(timeout: 5) {
            tableCellTest()
        } else {
            
        }
    }
    
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
