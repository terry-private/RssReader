//
//  ArticleDetailUITests.swift
//  RssReaderUITests
//
//  Created by 若江照仁 on 2021/04/21.
//

import XCTest

class ArticleDetailUITests: XCTestCase {
    let app = XCUIApplication()
    let safariApp = XCUIApplication(bundleIdentifier: "com.apple.movilesafari")
    let articleDetailPage = ArticleDetailViewPage()
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments.append("-isUITest")
        app.launch()
    }
    func testAfterLogin() throws {
        if ArticleListViewPage().collectionViewFirstCell.exists {
            ArticleListViewPage().collectionViewFirstCell.view.tap()
        }
        articleDetailPage.nextButton.tap()
        articleDetailPage.previousButton.tap()
        articleDetailPage.notLaterReadButton.tap()
        articleDetailPage.laterReadButton.tap()
        articleDetailPage.safariButton.tap()
        let _ = safariApp.wait(for: .runningForeground, timeout: 3)
        app.activate()
    }
}
