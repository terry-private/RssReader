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
        static let lineLoginButton = "line_login_button"
        static let mailLoginButton = "mail_login_button"
        static let dummyLoginButton = "dummy_login_button"
    }
    var pageTitle: XCUIElement {
        return app.navigationBars[A11y.pageTitle].firstMatch
    }
    var lineLoginButton: XCUIElement {
        return app.buttons[A11y.lineLoginButton]
    }
    var mailLoginButton: XCUIElement {
        return app.buttons[A11y.mailLoginButton]
    }
    var dummyLoginButton: XCUIElement {
        return app.buttons[A11y.dummyLoginButton]
    }
}
