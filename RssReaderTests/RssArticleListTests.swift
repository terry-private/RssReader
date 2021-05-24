//
//  RssArticleListTests.swift
//  RssReaderTests
//
//  Created by 若江照仁 on 2021/05/24.
//

import XCTest
@testable import RssReader

class RssArticleListTests: XCTestCase {
    func testFetch() throws {
        let expectation = self.expectation(description: "API")
        // 引数はurlStringだけにしたい。また、API 呼び出しは非同期なので、
        // コールバックをとるはず（注: RssArticleList.fetch はあとで定義する）。
        RssArticleList.fetch(urlString: QiitaType().makeJsonUrl(tag: "swift")) { errorOrArticle in
            // エラーかレスポンスがきたらコールバックが実行されて欲しい。
            // できれば、結果はすでに変換済みの RssArticleList オブジェクトを受け取りたい。
            
            switch errorOrArticle {
            case let .left(error):
                // エラーがきたらわかりやすいようにする。
                XCTFail("\(error)")
                
            case let .right(article):
                // 結果をきちんと受け取れたことを確認する。
                XCTAssertNotNil(article)
                print(article.feed.title)
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 10)
    }

}
