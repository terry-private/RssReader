//
//  DummyLoginAlert.swift
//  RssReaderUITests
//
//  Created by 若江照仁 on 2021/04/09.
//

import XCTest

class DummyLoginAlert {
    enum A11y {
        static let alert = "dummy_login_alert"

        static let loginIdTextField = "dummy_login_id_textField"
        static let cancelButton = "キャンセル"
        static let loginButton = "ログイン"
        static let errorAlert = "dummy_login_error_alert"
    }
    var app: XCUIApplication {
        return XCUIApplication()
    }
    var alert: XCUIElement {
        return app.alerts[A11y.alert]
    }
    var exists: Bool {
        return alert.exists
    }
    
    var loginIdTextField: XCUIElement {
        return alert.textFields[A11y.loginIdTextField]
    }
    var cancelButton: XCUIElement {
        return alert.buttons[A11y.cancelButton]
    }
    var loginButton: XCUIElement {
        return alert.buttons[A11y.loginButton]
    }
    
    // errorAlert関連
    var errorAlert: XCUIElement {
        return app.alerts[A11y.errorAlert]
    }
    func tappedErrorAlertOKButton() {
        errorAlert.scrollViews.otherElements.buttons["OK"].tap()
    }
    
}
