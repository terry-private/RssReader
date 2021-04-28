//
//  extension_XCUIApplication.swift
//  RssReaderUITests
//
//  Created by 若江照仁 on 2021/04/20.
//

import XCTest

extension XCUIApplication {
    var returnKey: XCUIElement {
        // 日本語のキーボードのみ対応することにします。
        // キーボードの表示アニメーションのラグを考慮して1秒探します。
        if keyboards.buttons["完了"].waitForExistence(timeout: 1) {
            return keyboards.buttons["完了"]
        } else {
            return keyboards.buttons["done"]
        }
    }
}
