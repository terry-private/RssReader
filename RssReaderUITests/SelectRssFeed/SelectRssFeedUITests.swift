//
//  SelectRssFeedUITests.swift
//  RssReaderUITests
//
//  Created by 若江照仁 on 2021/04/14.
//

import XCTest

class SelectRssFeedUITests: XCTestCase {
    let app = XCUIApplication()
    let mainTabBar = MainTabBar()
    let selectedRssFeedPage = SelectRssFeedViewPage()
    let selectRssFeedTypePage = SelectRssFeedTypeViewPage()
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
   
    // MARK:- mailLoginUITest
    // ○: 056~063 065~067 070~071 073~076 078~080
    // △: 019 033 034
    // ✖︎: 064 068
    // RssFeedの登録がない状態でテストしてください。
    func testNoneOfSelectedRssFeed() throws {
        if !selectedRssFeedPage.exists {
            mainTabBar.settingBar.tap()
            mainTabBar.articleListBar.tap()
        }
        
        XCTAssertTrue(selectedRssFeedPage.exists)
        
        // test 056
        XCTAssertEqual(selectedRssFeedPage.selectedCountLabel.label, "0")
        
        // test 057
        XCTAssertFalse(selectedRssFeedPage.confirmButton.isEnabled)
        
        // test 058 最初のセルに「購読する記事を追加」があるかどうか
        XCTAssertTrue(selectedRssFeedPage.selectRssFeedTable.cells.firstMatch.staticTexts["購読する記事を追加"].exists)
        
        // test 059
        selectedRssFeedPage.addTypeCell.tap()
        XCTAssertTrue(selectRssFeedTypePage.exists)
        
        // test 073
        XCTAssertTrue(selectRssFeedTypePage.qiitaCell.exists)
        XCTAssertTrue(selectRssFeedTypePage.yahooCell.exists)
        
        // test 074
        // キャンセルボタンでRSS Feed Type選択画面を閉じる
        selectRssFeedTypePage.cancelButton.tap()
        XCTAssertFalse(selectRssFeedTypePage.exists)
        
        // test 075
        // スワイプダウンでRSS Feed Type選択画面を閉じる
        // ナビゲーションバーがラージサイズになっているときだけの反応なので一度スワイプでデナビゲーションバーをラージサイズにしておきます。
        selectedRssFeedPage.addTypeCell.tap()
        selectRssFeedTypePage.view.swipeDown()
        selectRssFeedTypePage.view.swipeDown()
        XCTAssertFalse(selectRssFeedTypePage.exists)
        
        // test 076
        selectedRssFeedPage.addTypeCell.tap()
        selectRssFeedTypePage.qiitaCell.tap()
        XCTAssertTrue(selectRssFeedTypePage.qiitaAlert.exists)
        
        // test 078
        selectRssFeedTypePage.alertCancelButton.tap()
        XCTAssertFalse(selectRssFeedTypePage.qiitaAlert.exists)
        
        // test 079
        selectRssFeedTypePage.qiitaCell.tap()
        selectRssFeedTypePage.alertConfirmButton.tap()
        XCTAssertFalse(selectRssFeedTypePage.qiitaAlert.exists)
        
        // test 080
        selectRssFeedTypePage.qiitaCell.tap()
        selectRssFeedTypePage.alertTextField.typeText("swift")
        selectRssFeedTypePage.alertConfirmButton.tap()
        XCTAssertFalse(selectRssFeedTypePage.qiitaAlert.exists)
        
        // test 060
        XCTAssertEqual(selectedRssFeedPage.selectedCountLabel.label, "1")
        
        // test 061
        XCTAssertTrue(selectedRssFeedPage.confirmButton.isEnabled)
        
        // test 062
        XCTAssertTrue(selectedRssFeedPage.selectRssFeedTable.cells.firstMatch.staticTexts["swift"].exists)
        
        // test 063
        // 現在のセル数と同じRSS Feed Typeを追加した後のセル数を比較します。
        let cellsCount = selectedRssFeedPage.selectRssFeedTable.cells.count
        selectedRssFeedPage.addTypeCell.tap()
        selectRssFeedTypePage.qiitaCell.tap()
        selectRssFeedTypePage.alertTextField.typeText("swift")
        selectRssFeedTypePage.alertConfirmButton.tap()
        XCTAssertEqual(selectedRssFeedPage.selectRssFeedTable.cells.count, cellsCount)
        
        
        // ここから一つのセルの中身にあるオブジェクトの存在確認をします。
        let cell = selectedRssFeedPage.selectRssFeedTable.cells.firstMatch
        
        
        
        // test 065
        XCTAssertTrue(cell.staticTexts["Qiita"].exists)
        
        // test 066
        XCTAssertTrue(cell.staticTexts["swift"].exists)
        
        // test 067
        cell.swipeLeft()
        XCTAssertTrue(app.buttons["Delete"].exists)
        
        // test 069
        app.buttons["Delete"].tap()
        XCTAssertEqual(selectedRssFeedPage.selectRssFeedTable.cells.count, 1)
        
        // test 070
        XCTAssertEqual(selectedRssFeedPage.selectedCountLabel.label, "0")
        
        // test 071
        XCTAssertFalse(selectedRssFeedPage.confirmButton.isEnabled)
        
    }
    
}
