//
//  FilterMenuViewPage.swift
//  RssReaderUITests
//
//  Created by 若江照仁 on 2021/04/22.
//

import XCTest

final class FilterMenuViewPage: PageObjectable {
    enum A11y {
        static let view = "filterMenu_view"
        static let sortTypeSegmentedControl = "filterMenu_sortType_segmentedControl"
        static let orderBySegmentedControl = "filterMenu_orderBy_segmentedControl"
        static let containReadSwitch = "filterMenu_containRead_switch"
        static let notContainReadSwitch = "filterMenu_notContainRead_switch"
        static let pubDateAfterSegmentedControl = "filterMenu_pubDateAfter_segmentedControl"
        static let rssFeedCell = "filterMenu_rssFeed_cell"
        static let rssFeedTagLabel = "filterMenu_rssFeedTag_label"
        static let rssFeedDisplaySwitch = "filterMenu_rssFeedDisplay_switch"
        static let rssFeedNotDisplaySwitch = "filterMenu_rssFeedNotDisplay_switch"
    }
    var view: XCUIElement {
        return app.otherElements[A11y.view].firstMatch
    }
    var sortTypeSegmentedControl: XCUIElement {
        return view.tables.firstMatch.segmentedControls[A11y.sortTypeSegmentedControl]
    }
    var orderBySegmentedControl: XCUIElement {
        return view.tables.firstMatch.segmentedControls[A11y.orderBySegmentedControl]
    }
    var pubDateAfterSegmentedControl: XCUIElement {
        return view.tables.firstMatch.segmentedControls[A11y.pubDateAfterSegmentedControl]
    }
    
    // MARK:- メソッド
    @discardableResult
    func to発行日順() -> Self {
        sortTypeSegmentedControl.buttons["発行日順"].tap()
        return self
    }
    @discardableResult
    func to記事タイプ順() -> Self {
        sortTypeSegmentedControl.buttons["記事タイプ順"].tap()
        return self
    }
    @discardableResult
    func to降順() -> Self {
        orderBySegmentedControl.buttons["降順"].tap()
        return self
    }
    @discardableResult
    func to昇順() -> Self {
        orderBySegmentedControl.buttons["昇順"].tap()
        return self
    }
    @discardableResult
    func to表示日数(_ 日: Int) -> Self{
        pubDateAfterSegmentedControl.buttons["\(日)日"].tap()
        return self
    }
}
