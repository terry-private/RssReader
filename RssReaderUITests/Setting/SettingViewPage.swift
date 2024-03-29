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
        static let timeIntervalSegmentedControl = "setting_timeInterval_segmentedControl"
        static let displayModeSegmentedControl = "setting_displayMode_segmentedControl"
        
        // RssFeedCell
        static let rssFeedFirstCell = "setting_rssFeed_cell"
        static let faviconImage = "rssFeedTableViewCell_favicon_image"
        static let titleLabel = "rssFeedTableViewCell_title_label"
        static let tagNameLabel = "rssFeedTableViewCell_tagName_label"
        static let addRssFeedCell = "setting_addRssFeed_cell"
        static let swipeDeleteButton = "Delete"
        
        // LINE logout alert
        static let alert = "setting_lineLogout_alert"
    }
    var view: XCUIElement {
        return app.otherElements[A11y.view].firstMatch
    }
    var table: XCUIElement {
        return view.tables[A11y.table]
    }
    var accountCell: XCUIElement {
        return table.cells[A11y.accountCell]
    }
    var accountImage: XCUIElement {
        return accountCell.images[A11y.accountImage]
    }
    var accountNameLabel: XCUIElement {
        return accountCell.staticTexts[A11y.accountNameLabel]
    }
    var timeIntervalSegmentedControl: XCUIElement {
        return app.segmentedControls[A11y.timeIntervalSegmentedControl]
    }
    var displayModeSegmentedControl: XCUIElement {
        return app.segmentedControls[A11y.displayModeSegmentedControl]
    }
    
    // RssFeedCell
    var rssFeedFirstCell: XCUIElement {
        return table.cells[A11y.rssFeedFirstCell].firstMatch
    }
    var firstFaviconImage: XCUIElement {
        return rssFeedFirstCell.images[A11y.faviconImage]
    }
    var firstRssFeedTitle: XCUIElement {
        return rssFeedFirstCell.staticTexts[A11y.titleLabel]
    }
    var firstTagName: XCUIElement {
        return rssFeedFirstCell.staticTexts[A11y.tagNameLabel]
    }
    var firstCellSwipeDeleteButton: XCUIElement {
        return rssFeedFirstCell.buttons[A11y.swipeDeleteButton]
    }
    var rssFeedCount: Int {
        return table.cells.count - 1
    }

    // AddRssFeedCell
    var addRssFeedCell: XCUIElement {
        return table.cells[A11y.addRssFeedCell]
    }
    
    // LINE logout alert
    var alert: XCUIElement {
        return app.alerts[A11y.alert]
    }
    
    var alertCancelButton: XCUIElement {
        return alert.buttons["キャンセル"].firstMatch
    }
    
    var alertLogoutButton: XCUIElement {
        return alert.buttons["ログアウト"].firstMatch
    }
    
    var alertRefreshButton: XCUIElement {
        return alert.buttons["トークンの更新"]
    }
    
    // MARK:- メソッド
    @discardableResult
    func toAccountProperty() -> AccountPropertyViewPage {
        accountCell.tap()
        return AccountPropertyViewPage()
    }
    
    func addNewQiita(_ tag: String) {
        addRssFeedCell.tap()
        SelectRssFeedTypeViewPage().addNewQiita(tag)
    }
}
