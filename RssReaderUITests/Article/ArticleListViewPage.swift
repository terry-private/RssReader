//
//  ArticleListViewPage.swift
//  RssReaderUITests
//
//  Created by 若江照仁 on 2021/04/15.
//

import XCTest

final class ArticleListViewPage: PageObjectable {
    enum A11y {
        static let view = "articleList_view"
        static let articleListTable = "articleList_table"
        static let articleListCollectionView = "articleList_collectionView"
        static let filterMenuButton = "articleList_filterMenu_Button"
    }
    var view: XCUIElement {
        return app.otherElements[A11y.view].firstMatch
    }
    var filterMenuButton: XCUIElement { return app.buttons[A11y.filterMenuButton]
    }
    var table: XCUIElement {
        return app.tables[A11y.articleListTable]
    }
    var collectionView: XCUIElement {
        return app.collectionViews[A11y.articleListCollectionView]
    }
    var tableFirstCell: ArticleTableViewFirstCell {
        return ArticleTableViewFirstCell(table: table)
    }
}


