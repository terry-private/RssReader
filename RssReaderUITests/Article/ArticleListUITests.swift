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
        // 最初のセルの記事のタイトルを取得しておきます。
        let firstCellArticleTitle = articleListPage.tableFirstCell.articleTitleLabel.label
        
        //test 105
        //一旦
        if articleListPage.tableFirstCell.isRead {
            articleListPage.tableFirstCell.view.swipeLeft()
            articleListPage.tableFirstCell.readButton.tap()
        }
        XCTAssertTrue(articleListPage.tableFirstCell.isRead)
        
        if articleListPage.tableFirstCell.isRead {
            articleListPage.tableFirstCell.view.swipeLeft()
            articleListPage.tableFirstCell.readButton.tap()
        }
        XCTAssertFalse(articleListPage.tableFirstCell.isRead)
        
        if articleListPage.tableFirstCell.isStar {
            articleListPage.tableFirstCell.view.swipeRight()
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
