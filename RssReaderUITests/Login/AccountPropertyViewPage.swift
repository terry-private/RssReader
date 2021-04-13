//
//  AccountPropertyViewPage.swift
//  RssReaderUITests
//
//  Created by 若江照仁 on 2021/04/13.
//

import XCTest

final class AccountPropertyViewPage: PageObjectable {
    enum A11y {
        static let view = "accountProperty_view"
        static let profileImageButton = "accountProperty_profileImage_button"
        static let mailTextField = "accountProperty_mail_textField"
        static let passwordTextField = "accountProperty_password_textField"
        static let usernameTextField = "accountProperty_username_textField"
        static let confirmButton = "accountProperty_confirm_button"
        static let logoutButton = "accountProperty_logout_button"
        static let backButton = "back"
        static let closeButton = "閉じる"
    }
    var view: XCUIElement {
        return app.otherElements[A11y.view]
    }
    var mailTextField: XCUIElement {
        return app.textFields[A11y.mailTextField]
    }
    var passwordTextField: XCUIElement {
        return app.secureTextFields[A11y.passwordTextField]
    }
    var confirmButton: XCUIElement {
        return app.buttons[A11y.confirmButton]
    }
    var logoutButton: XCUIElement {
        return app.buttons[A11y.logoutButton]
    }
    var backButton: XCUIElement {
        return app.buttons[A11y.backButton].firstMatch
    }
    var closeButton: XCUIElement {
        return app.buttons[A11y.closeButton].firstMatch
    }
}
