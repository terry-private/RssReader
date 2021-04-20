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
}
