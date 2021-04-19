//
//  SettingUITests.swift
//  RssReaderUITests
//
//  Created by 若江照仁 on 2021/04/19.
//

import XCTest

class SettingUITests: XCTestCase {
    let app = XCUIApplication()
    let articleListPage = ArticleListViewPage()
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments.append("-isUITest")
        app.launch()
    }

    func testAfterLogin() throws {
        
    }

}
