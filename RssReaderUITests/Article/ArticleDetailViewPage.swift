//
//  ArticleDetailViewPage.swift
//  RssReaderUITests
//
//  Created by 若江照仁 on 2021/04/21.
//

import XCTest

final class ArticleDetailViewPage: PageObjectable {
    enum A11y {
        static let view = "articleDetail_view"
        static let webView = "articleDetail_webView"
        static let closeButton = "articleDetail_close_button"
        static let starButton = "articleDetail_star_button"
        static let notStarButton = "articleDetail_notStar_button"
        static let previousButton = "Back"
        static let nextButton = "Forward"
        static let laterReadButton = "articleDetail_laterRead_button"
        static let notLaterReadButton = "articleDetail_notLaterRead_button"
        static let safariButton = "safari"
    }
    
    var view: XCUIElement {
        return app.otherElements[A11y.view].firstMatch
    }
    var webView: XCUIElement {
        return view.webViews[A11y.webView]
    }
    var closeButton: XCUIElement {
        return app.navigationBars.firstMatch.buttons[A11y.closeButton]
    }
    var starButton: XCUIElement {
        return app.navigationBars.firstMatch.buttons[A11y.starButton]
    }
    var notStarButton: XCUIElement {
        return app.navigationBars.firstMatch.buttons[A11y.notStarButton]
    }
    var previousButton: XCUIElement {
        return app.toolbars.firstMatch.buttons[A11y.previousButton]
    }
    var nextButton: XCUIElement {
        return app.toolbars.firstMatch.buttons[A11y.nextButton]
    }
    var laterReadButton: XCUIElement {
        return app.buttons[A11y.laterReadButton]
    }
    var notLaterReadButton: XCUIElement {
        return app.toolbars.firstMatch.buttons[A11y.notLaterReadButton]
    }
    var safariButton: XCUIElement {
        return app.toolbars.firstMatch.buttons[A11y.safariButton]
    }
}
