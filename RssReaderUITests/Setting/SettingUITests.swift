//
//  SettingUITests.swift
//  RssReaderUITests
//
//  Created by 若江照仁 on 2021/04/19.
//

import XCTest

class SettingUITests: XCTestCase {
    let app = XCUIApplication()
    let settingPage = SettingViewPage()
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments.append("-isUITest")
        app.launch()
    }

    func testAfterLogin() throws {
        MainTabBar().settingBar.tap()
        settingPage.elementsExist([
            settingPage.view,
            settingPage.table,
            settingPage.accountCell,
            settingPage.accountImage,
            settingPage.accountNameLabel,
            settingPage.timeIntervalSegmentedControl,
            settingPage.displayModeSegmentedControl,
            settingPage.rssFeedFirstCell,
            settingPage.firstFaviconImage,
            settingPage.firstRssFeedTitle,
            settingPage.firstTagName,
            settingPage.addRssFeedCell
        ], timeout: 1)
    
    }

}
