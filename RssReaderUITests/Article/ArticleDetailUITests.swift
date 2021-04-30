//
//  ArticleDetailUITests.swift
//  RssReaderUITests
//
//  Created by 若江照仁 on 2021/04/21.
//

import XCTest

class ArticleDetailUITests: XCTestCase {
    let app = XCUIApplication()
    let mainTabBar = MainTabBar()
    let safariApp = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
    let articleDetailPage = ArticleDetailViewPage()
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments.append("-isUITest")
        app.launch()
    }
    func testAfterLogin() throws {
        // test 95 141 187
        allCellTapTest()

        // test 284
        XCTContext.runActivity(named: "test 284") { _ in
            articleDetailPage.closeButton.tap()
            XCTAssertFalse(articleDetailPage.view.exists)
        }
        
        mainTabBar.toArticleListPage().tableFirstCell.view.tap()
        
        // test 285 286
        // 条件によって順番が前後するので関数で定義しておきます。
        func test285() {
            // 「スター」ボタン（黄色：お気に入り）タップ動作確認
            XCTContext.runActivity(named: "test 285") { _ in
                articleDetailPage.starButton.tap()
                XCTAssertTrue(articleDetailPage.notStarButton.exists)
            }
        }
        
        func test286() {
            // 「スター」ボタン（グレー枠のみ：お気に入りではない）タップ動作確認
            XCTContext.runActivity(named: "test 286") { _ in
                articleDetailPage.notStarButton.tap()
                XCTAssertTrue(articleDetailPage.starButton.exists)
            }
        }
        
        if articleDetailPage.starButton.exists {
            test285()
            test286()
        } else {
            test286()
            test285()
        }
        
        // test 287 288
        // 条件によって順番が前後するので関数で定義しておきます。
        func test287() {
            // 「トレイ」ボタン（緑：後で読む）タップ動作確認
            XCTContext.runActivity(named: "test 285") { _ in
                articleDetailPage.starButton.tap()
                XCTAssertTrue(articleDetailPage.notStarButton.exists)
            }
        }
        
        func test288() {
            // 「トレイ」ボタン（青枠のみ：後で読むではない）タップ動作確認
            XCTContext.runActivity(named: "test 286") { _ in
                articleDetailPage.notStarButton.tap()
                XCTAssertTrue(articleDetailPage.starButton.exists)
            }
        }
        
        if articleDetailPage.starButton.exists {
            test287()
            test288()
        } else {
            test288()
            test287()
        }
        
        // test 289
        // コンパス「ボタン」の動作確認
        XCTContext.runActivity(named: "test 289") { _ in
            articleDetailPage.safariButton.tap()
            XCTAssertTrue(safariApp.wait(for: .runningForeground, timeout: 10))
        }
        app.activate()
    }
    
    /// 全ての記事セルをタップして詳細画面へ遷移できるかどうかのテストまとめ
    /// test 95 141 187
    private func allCellTapTest() {
        // test 95
        // 最新記事画面のセル（テーブル、コレクション両方）タップの動作確認
        XCTContext.runActivity(named: "test 95"){ _ in
            // コレクションセルタップ動作確認
            ArticleListViewPage().collectionViewFirstCell.view.tap()
            XCTAssertTrue(articleDetailPage.exists)
            // 閉じる
            articleDetailPage.closeButton.tap()
            // テーブルセルタップ動作確認
            mainTabBar
                .toTableView()
                .toArticleListPage()
                .tableFirstCell.view.tap()
            XCTAssertTrue(articleDetailPage.exists)
        }
        
        // 閉じる
        articleDetailPage.closeButton.tap()
        
        // test 141
        // 後で読む画面のセル（テーブル、コレクション両方）タップの動作確認
        XCTContext.runActivity(named: "test 141"){ _ in
            // テーブルセルタップ動作確認
            mainTabBar.toLaterReadPage().tableFirstCell.view.tap()
            XCTAssertTrue(articleDetailPage.exists)
            // 閉じる
            articleDetailPage.closeButton.tap()
            // コレクションセルタップ動作確認
            mainTabBar
                .toCollectionView()
                .toLaterReadPage()
                .collectionViewFirstCell.view.tap()
            XCTAssertTrue(articleDetailPage.exists)
        }
        
        // 閉じておきます。
        articleDetailPage.closeButton.tap()
        
        // test 187
        // お気に入り画面のセル（テーブル、コレクション両方）タップの動作確認
        XCTContext.runActivity(named: "test 187"){ _ in
            // コレクションセルタップ動作確認
            mainTabBar.toStarListPage().collectionViewFirstCell.view.tap()
            XCTAssertTrue(articleDetailPage.exists)
            // 閉じる
            articleDetailPage.closeButton.tap()
            // テーブルセルタップ動作確認
            mainTabBar
                .toTableView()
                .toArticleListPage()
                .tableFirstCell.view.tap()
            XCTAssertTrue(articleDetailPage.exists)
        }
    }
}
