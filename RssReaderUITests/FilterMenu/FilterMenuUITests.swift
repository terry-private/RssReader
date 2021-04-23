//
//  FilterMenuUITests.swift
//  RssReaderUITests
//
//  Created by 若江照仁 on 2021/04/22.
//

import XCTest

class FilterMenuUITests: XCTestCase {
    let app = XCUIApplication()
    let articleListPage = ArticleListViewPage()
    let mainTabBar = MainTabBar()
    let filterMenuPage = FilterMenuViewPage()
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments.append("-isUITest")
        app.launch()
    }
    
    func testAfterLogin() throws {
        // test 93 139 185
        openFilterMenuTest()
    }
    
    /// 全ての記事セルをタップして詳細画面へ遷移できるかどうかのテストまとめ
    /// test 93 139 185
    private func openFilterMenuTest() {
        // test 93
        // 最新記事画面のセル（テーブル、コレクション両方）タップの動作確認
        XCTContext.runActivity(named: "test 93"){ _ in
            articleListPage.filterMenuButton.tap()
            XCTAssertTrue(filterMenuPage.exists)
        }
        
        // test 139
        // 最新記事画面のセル（テーブル、コレクション両方）タップの動作確認
        XCTContext.runActivity(named: "test 139"){ _ in
            mainTabBar.toLaterReadPage().filterMenuButton.tap()
            XCTAssertTrue(filterMenuPage.exists)
        }
        
        // test 185
        // 最新記事画面のセル（テーブル、コレクション両方）タップの動作確認
        XCTContext.runActivity(named: "test 185"){ _ in
            mainTabBar.toStarListPage().filterMenuButton.tap()
            XCTAssertTrue(filterMenuPage.exists)
        }
    }
}
