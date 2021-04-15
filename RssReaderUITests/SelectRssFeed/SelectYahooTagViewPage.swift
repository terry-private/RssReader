//
//  SelectYahooTagViewPage.swift
//  RssReaderUITests
//
//  Created by 若江照仁 on 2021/04/15.
//

import XCTest

final class SelectYahooTagViewPage: PageObjectable {
    enum A11y {
        static let view = "selectYahooTag_view"
        static let selectYahooTagTable = "selectYahooTag_table"
    }
    var view: XCUIElement {
        return app.otherElements[A11y.view].firstMatch
    }
    var table: XCUIElement {
        return app.tables[A11y.selectYahooTagTable]
    }
    var backButton: XCUIElement {
        return app.navigationBars["Yahoo!Newsタグの選択"].firstMatch.buttons.firstMatch
    }
    var cells: [XCUIElement] {
        return table.cells.allElementsBoundByIndex
    }
}
