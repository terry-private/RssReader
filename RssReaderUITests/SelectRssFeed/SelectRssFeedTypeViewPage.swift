//
//  SelectRssFeedTypeViewPage.swift
//  RssReaderUITests
//
//  Created by 若江照仁 on 2021/04/15.
//

import XCTest

class SelectRssFeedTypeViewPage: PageObjectable {
    enum A11y {
        static let view = "selectRssFeedType_view"
        static let cancelButton = "キャンセル"
        static let table = "selectRssFeedType_table"
        static let qiitaCell = "selectRssFeedType_qiita_cell"
        static let yahooCell = "selectRssFeedType_yahoo_cell"
        static let qiitaAlert = "qiita_alert"
        static let alertTextField = "alert_textField"
        static let alertCancelButton = "キャンセル"
        static let alertConfirmButton = "確定"
    }
    var view: XCUIElement {
        return app.otherElements[A11y.view].firstMatch
    }
    var cancelButton: XCUIElement {
        return app.buttons[A11y.cancelButton].firstMatch
    }
    var table: XCUIElement {
        return view.tables[A11y.table]
    }
    var qiitaCell: XCUIElement {
        return table.cells[A11y.qiitaCell]
    }
    var yahooCell: XCUIElement {
        return table.cells[A11y.yahooCell]
    }
    var qiitaAlert: XCUIElement {
        return app.alerts[A11y.qiitaAlert]
    }
    var alertTextField: XCUIElement {
        return qiitaAlert.textFields[A11y.alertTextField]
    }
    var alertCancelButton: XCUIElement {
        return qiitaAlert.buttons[A11y.alertCancelButton]
    }
    var alertConfirmButton: XCUIElement {
        return qiitaAlert.buttons[A11y.alertConfirmButton]
    }
}
