//
//  LaterReadListUITests.swift
//  RssReaderUITests
//
//  Created by 若江照仁 on 2021/04/21.
//

import XCTest

class LaterReadListUITests: XCTestCase {
    let app = XCUIApplication()
    let laterReadPage = LaterReadListViewPage()
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments.append("-isUITest")
        app.launch()
    }

    func testAfterLogin() throws {
        MainTabBar().laterReadBar.tap()
        collectionViewCellTest()
    }
    // MARK:- コレクションビューのテスト
    private func collectionViewCellTest() {
        // test 171
        // 記事セルロングタップの動作確認
        XCTContext.runActivity(named: "test 171") { _ in
            laterReadPage.collectionViewFirstCell.view.press(forDuration: 1)
            XCTAssertTrue(laterReadPage.collectionViewFirstCell.isOpenContextMenu)
        }
        
        // test 178
        // 任意の箇所をタップでコンテクストメニューが閉じるかどうか
        XCTContext.runActivity(named: "test 178") { _ in
            app.tap()
            XCTAssertFalse(laterReadPage.collectionViewFirstCell.isOpenContextMenu)
        }
        
        // test 179
        // お気に入り解除ボタンの動作確認
        XCTContext.runActivity(named: "test 179") { _ in
            
        }
        
        // test 180
        // お気に入りボタンの動作確認
        XCTContext.runActivity(named: "test 180") { _ in
            
        }
        
        // test 181
        // 未読にするボタンの動作確認
        XCTContext.runActivity(named: "test 181") { _ in
            
        }
        
        // test 182
        // 既読にするボタンの動作確認
        XCTContext.runActivity(named: "test 182") { _ in
            
        }
        
        // test 183
        // 後で読むを解除するボタンの動作確認
        XCTContext.runActivity(named: "test 183") { _ in
            
        }
    }
}
