//
//  MailLoginViewPage.swift
//  RssReaderUITests
//
//  Created by 若江照仁 on 2021/04/12.
//

import XCTest

final class MailLoginViewPage: PageObjectable {
    enum A11y {
        static let pageTitle = "メールログイン"
        static let mailTextField = "mailLogin_mail_textField"
        static let passwordTextField = "mailLogin_password_textField"
        static let mailLoginButton = "mailLogin_login_button"
        static let backButton = "ログイン"
    }
    var pageTitle: XCUIElement {
        return app.navigationBars[A11y.pageTitle].firstMatch
    }
    var mailTextField: XCUIElement {
        return app.textFields[A11y.mailTextField]
    }
    var passwordTextField: XCUIElement {
        return app.secureTextFields[A11y.passwordTextField]
    }
    var mailLoginButton: XCUIElement {
        return app.buttons[A11y.mailLoginButton]
    }
    var backButton: XCUIElement {
        return app.buttons[A11y.backButton].firstMatch
    }
}

