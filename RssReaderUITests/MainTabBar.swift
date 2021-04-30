//
//  MainTabBar.swift
//  RssReaderUITests
//
//  Created by 若江照仁 on 2021/04/14.
//

import XCTest

class MainTabBar {
    let app = XCUIApplication()
    var bar: XCUIElement {
        return app.tabBars["main_tabBar"]
    }
    var articleListBar: XCUIElement {
        return bar.buttons["articleList_bar"]
    }
    var laterReadBar: XCUIElement {
        return bar.buttons["laterRead_bar"]
    }
    var starListBar: XCUIElement {
        return bar.buttons["starList_bar"]
    }
    var settingBar: XCUIElement {
        return bar.buttons["setting_bar"]
    }
    
    // tableViewへの切り替え動作
    @discardableResult
    func toTableView() -> Self {
        MainTabBar().settingBar.tap()
        SettingViewPage().displayModeSegmentedControl.buttons["line.horizontal.3.decrease"].tap()
        return self
    }
    
    // collectionViewへの切り替え動作
    @discardableResult
    func toCollectionView() -> Self {
        MainTabBar().settingBar.tap()
        SettingViewPage().displayModeSegmentedControl.buttons["grid 2x2"].tap()
        return self
    }
    
    // 各ページへの遷移をメソッドチェーン可能な関数を定義しておきます。
    @discardableResult
    func toArticleListPage() -> ArticleListViewPage {
        articleListBar.tap()
        return ArticleListViewPage()
    }
    
    @discardableResult
    func toLaterReadPage() -> LaterReadListViewPage {
        laterReadBar.tap()
        return LaterReadListViewPage()
    }
    
    @discardableResult
    func toStarListPage() -> StarListViewPage {
        starListBar.tap()
        return StarListViewPage()
    }
}
