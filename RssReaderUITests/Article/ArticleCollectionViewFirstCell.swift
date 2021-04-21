//
//  ArticleCollectionViewFirstCell.swift
//  RssReaderUITests
//
//  Created by 若江照仁 on 2021/04/16.
//

import XCTest

final class ArticleCollectionViewFirstCell: PageObjectable {
    enum A11y {
        // セルの中身
        static let articleTitleLabel = "collectionViewCell_articleTitle_label"
        static let starImage = "collectionViewCell_star_image"
        static let unStarImage = "collectionViewCell_unStar_image"
        static let readImage = "collectionViewCell_read_image"
        static let unReadImage = "collectionViewCell_unRead_image"
        
        // コンテテクストメニュー
        static let readButton = "collectionView_read_button"
        static let unReadButton = "collectionView_unRead_button"
        static let starButton = "collectionView_star_button"
        static let unStarButton = "collectionView_unStar_button"
        static let laterReadButton = "collectionView_laterRead_button"
        static let unLaterReadButton = "collectionView_unLaterRead_button"
    }
    
    private let collectionView: XCUIElement
    init(collectionView: XCUIElement) {
        self.collectionView = collectionView
    }
    var view: XCUIElement {
        return collectionView.cells.firstMatch
    }
    
    // セルの中身
    var articleTitleLabel: XCUIElement {
        return view.staticTexts[A11y.articleTitleLabel]
    }
    var starImage: XCUIElement {
        return view.images[A11y.starImage]
    }
    var unStarImage: XCUIElement {
        return view.images[A11y.unStarImage]
    }
    var readImage: XCUIElement {
        return view.images[A11y.readImage]
    }
    var unReadImage: XCUIElement {
        return view.images[A11y.unReadImage]
    }
    
    // コンテテクストメニュー
    var readButton: XCUIElement {
        return app.buttons[A11y.readButton]
    }
    var unReadButton: XCUIElement {
        return app.buttons[A11y.unReadButton]
    }
    var starButton: XCUIElement {
        return app.buttons[A11y.starButton]
    }
    var unStarButton: XCUIElement {
        return app.buttons[A11y.unStarButton]
    }
    var laterReadButton: XCUIElement {
        return app.buttons[A11y.laterReadButton]
    }
    var unLaterReadButton: XCUIElement {
        return app.buttons[A11y.unLaterReadButton]
    }
    
    // 状態
    var isOpenContextMenu: Bool {
        return readButton.exists || unReadButton.exists
    }
    var isStar: Bool {
        if isOpenContextMenu {
            return starButton.exists
        } else {
            return starImage.exists
        }
    }
    var isRead: Bool {
        if isOpenContextMenu {
            return readButton.exists
        } else {
            return readImage.exists
        }
    }
    var isLaterRead: Bool {
        if !isOpenContextMenu { fatalError() }
        return unLaterReadButton.exists
    }
}
