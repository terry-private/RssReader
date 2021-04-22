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
        static let pubDateAfterSegmentedControl = "filterMenu_pubDateAfter_segmentedControl"
        static let rssFeedCell = "filterMenu_rssFeed_cell"
        static let rssFeedTagLagel = "filterMenu_rssFeedTag_label"
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
}
