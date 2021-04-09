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
        return app.textFields[A11y.loginIdTextField]
    }
    var cancelButton: XCUIElement {
        return alert.scrollViews.otherElements.buttons[A11y.cancelButton]
    }
    var loginButton: XCUIElement {
        return alert.scrollViews.otherElements.buttons[A11y.loginButton]
    }
}
