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
    var cells: [String: XCUIElement] {
        return [
            "主要": table.cells["主要"].firstMatch,
            "国際": table.cells["国際"].firstMatch,
            "エンタメ": table.cells["エンタメ"].firstMatch,
            "IT": table.cells["IT"].firstMatch,
            "地域": table.cells["地域"].firstMatch,
            "国内": table.cells["国内"].firstMatch,
            "経済": table.cells["経済"].firstMatch,
            "スポーツ": table.cells["スポーツ"].firstMatch,
            "科学": table.cells["科学"].firstMatch
        ]
    }
}
