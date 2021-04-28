//
//  SelectRssFeedViewPage.swift
//  RssReaderUITests
//
//  Created by 若江照仁 on 2021/04/14.
//

import XCTest

final class SelectRssFeedViewPage: PageObjectable {
    enum A11y {
        static let view = "selectRssFeed_view"
        static let selectRssFeedTable = "selectRssFeed_table"
        static let selectedCountLabel = "selectRssFeed_selectedCount_label"
        static let confirmButton = "selectRssFeed_confirm_button"
    }
    var view: XCUIElement {
        return app.otherElements[A11y.view].firstMatch
    }
    var selectRssFeedTable: XCUIElement {
        return app.tables[A11y.selectRssFeedTable]
    }
    var selectedCountLabel: XCUIElement {
        return app.staticTexts[A11y.selectedCountLabel]
    }
    var addTypeCell: XCUIElement {
        let cellsCount = selectRssFeedTable.cells.count
        return selectRssFeedTable.cells.element(boundBy: cellsCount - 1)
    }
    var confirmButton: XCUIElement {
        return app.buttons[A11y.confirmButton]
    }
}
