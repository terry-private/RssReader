//
//  ArticleTableViewFirstCell.swift
//  RssReaderUITests
//
//  Created by 若江照仁 on 2021/04/16.
//

import XCTest

final class ArticleTableViewFirstCell: PageObjectable {
    enum A11y {
        // スワイプメニュー
        static let starButton = "tableCell_star_button"
        static let laterReadButton = "tableCell_laterRead_button"
        static let readButton = "tableCell_read_button"
        static let unReadButton = "tableCell_unRead_button"
        // セルの中身
        static let articleTitleLabel = "articleTableViewCell_articleTitle_label"
        static let readCheckImageView = "articleTableViewCell_read_image"
        static let starImageView = "articleTableViewCell_star_image"
    }
    private let table: XCUIElement
    init(table: XCUIElement) {
        self.table = table
    }
    var view: XCUIElement {
        return table.cells.firstMatch
    }
    // スワイプメニュー
    var starButton: XCUIElement {
        return view.buttons[A11y.starButton]
    }
    var laterReadButton: XCUIElement {
        return view.buttons[A11y.laterReadButton]
    }
    var readButton: XCUIElement {
        return view.buttons[A11y.readButton]
    }
    var unReadButton: XCUIElement {
        return view.buttons[A11y.unReadButton]
    }
    
    // セルの中身
    var articleTitleLabel: XCUIElement {
        return view.staticTexts[A11y.articleTitleLabel]
    }
    var readImage: XCUIElement {
        return view.images[A11y.readCheckImageView]
    }
    
    var starImage: XCUIElement {
        return view.images[A11y.starImageView]
    }
    
    // 状態フラグ
    var isRead: Bool {
        return readImage.exists
    }
    var isStar: Bool {
        return starImage.exists
    }
}
