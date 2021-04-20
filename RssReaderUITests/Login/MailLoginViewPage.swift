//
//  MailLoginViewPage.swift
//  RssReaderUITests
//
//  Created by 若江照仁 on 2021/04/12.
//

import XCTest

final class MailLoginViewPage: PageObjectable {
    enum A11y {
        static let view = "mailLogin_view"
        static let mailTextField = "mailLogin_mail_textField"
        static let passwordTextField = "mailLogin_password_textField"
        static let mailLoginButton = "mailLogin_login_button"
        static let newAccountButton = "mailLogin_newAccount_button"
        static let backButton = "ログイン"
        static let newAccountAlert = "mailLogin_newAccount_alert"
        static let alertCancelButton = "キャンセル"
        static let alertNewAccountButton = "新規アカウント作成"
    }
    var view: XCUIElement {
        return app.otherElements[A11y.view].firstMatch
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
    var newAccountButton: XCUIElement {
        return app.buttons[A11y.newAccountButton]
    }
    var backButton: XCUIElement {
        return app.buttons[A11y.backButton].firstMatch
    }
    
    // MARK:- 新規アカウント作成アラート
    var newAccountAlert: XCUIElement {
        return app.alerts[A11y.newAccountAlert]
    }
    var alertCancelButton: XCUIElement {
        return newAccountAlert.buttons[A11y.alertCancelButton]
    }
    var alertNewAccountButton: XCUIElement {
        return newAccountAlert.buttons[A11y.alertNewAccountButton]
    }
    
    func loginDummyMailAccount() {
        newAccountButton.tap()
        AccountPropertyViewPage().inputTestAccount().confirmButton.tap()
    }
}

