//
//  StarListViewPage.swift
//  RssReaderUITests
//
//  Created by 若江照仁 on 2021/04/21.
//

import XCTest

final class StarListViewPage: PageObjectable {
    enum A11y {
        static let view = "starList_view"
        static let articleListTable = "starList_table"
        static let articleListCollectionView = "starList_collectionView"
        static let filterMenuButton = "starList_filterMenu_Button"
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
    var collectionViewFirstCell: ArticleCollectionViewFirstCell {
        return ArticleCollectionViewFirstCell(collectionView: collectionView)
    }
}
