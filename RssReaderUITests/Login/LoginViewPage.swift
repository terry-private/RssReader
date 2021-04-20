//
//  LoginViewPage.swift
//  RssReaderUITests
//
//  Created by 若江照仁 on 2021/04/09.
//

import XCTest

final class LoginViewPage: PageObjectable {
    enum A11y {
        static let view = "login_view"
        static let lineLoginButton = "line_login_button"
        static let mailLoginButton = "mail_login_button"
        static let dummyLoginButton = "login_view"
    }
    var view: XCUIElement {
        return app.otherElements[A11y.view].firstMatch
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
    
    func loginDummyMailAccount() {
        mailLoginButton.tap()
        MailLoginViewPage().loginDummyMailAccount()
    }
}
