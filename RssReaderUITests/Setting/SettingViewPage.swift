//
//  SettingViewPage.swift
//  RssReaderUITests
//
//  Created by 若江照仁 on 2021/04/19.
//

import XCTest

final class SettingViewPage: PageObjectable {
    enum A11y {
        static let view = "setting_view"
        static let table = "setting_table"
        static let accountCell = "setting_account_cell"
        static let accountImage = "setting_account_image"
        static let accountNameLabel = "setting_accountName_label"
        static let timeIntervalSegmentControl = "setting_timeInterval_segmentControl"
        static let displayModeSegmentControl = "setting_displayMode_segmentControl"
        static let rssFeedFirstCell = "setting_rssFeed_cell"
    }
    var view: XCUIElement {
        return app.otherElements[A11y.view].firstMatch
    }
    var table: XCUIElement {
        return view.tables[A11y.table]
    }
    var accountCell: XCUIElement {
        return table.cells.element(boundBy: 0)
    }
    var accountImage: XCUIElement {
        return accountCell.images[A11y.accountImage]
    }
    var accountNameLabel: XCUIElement {
        return accountCell.staticTexts[A11y.accountNameLabel]
    }
    var timeIntervalSegmentControl: XCUIElement {
        return app.segmentedControls[A11y.timeIntervalSegmentControl]
    }
    var displayModeSegmentControl: XCUIElement {
        return app.segmentedControls[A11y.displayModeSegmentControl]
    }
    var rssFeedFirstCell: XCUIElement {
        return table.cells.element(boundBy: 3)
    }
}
