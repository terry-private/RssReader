//
//  LoginViewPage.swift
//  RssReaderUITests
//
//  Created by 若江照仁 on 2021/04/09.
//

import XCTest

final class LoginViewPage: PageObjectable {
    enum A11y {
        static let pageTitle = "ログイン"
    }
    var pageTitle: XCUIElement {
        return app.navigationBars[A11y.pageTitle].firstMatch
    }
    var lineLoginButton: XCUIElement {
        return app.buttons["line_login_button"]
    }
    var mailLoginButton: XCUIElement {
        return app.buttons["mail_login_button"]
    }
    var dummyLoginButton: XCUIElement {
        return app.buttons["dummy_login_button"]
    }
}
