//
//  PageObjectable.swift
//  RssReaderUITests
//
//  Created by 若江照仁 on 2021/04/09.
//

import XCTest

protocol PageObjectable {
    associatedtype A11y
    var app: XCUIApplication { get }
    var exists: Bool { get }
    var pageTitle: XCUIElement { get }
    func elementsExist(_ elements: [XCUIElement], timeout: Double) -> Bool
}

extension PageObjectable {
    var app: XCUIApplication {
        return XCUIApplication()
    }
    var exists: Bool {
        return elementsExist([pageTitle], timeout: 5)
    }
    func elementsExist(_ elements: [XCUIElement], timeout: Double) -> Bool {
        for element in elements {
            if !element.waitForExistence(timeout: timeout) {
                return false
            }
        }
        return true
    }
}
