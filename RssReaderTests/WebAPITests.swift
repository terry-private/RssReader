//
//  WebAPITests.swift
//  RssReaderTests
//
//  Created by 若江照仁 on 2021/05/21.
//

import XCTest
@testable import RssReader

class WebAPITests: XCTestCase {

    func testRequest() {
        let rssApiUrl = URL(string: QiitaType().makeJsonUrl(tag: "swift"))!
        // リクエストを作成する。
        let input: Request = (
            
            url: rssApiUrl,
            
            queries: [],
            
            // 特にヘッダーもいらない。
            headers: [:],
            
            // HTTP メソッドは GET のみ対応している。
            methodAndPayload: .get
        )
        
        // この内容で API を呼び出す（注: WebAPI.call は後で定義する）。
        WebAPI.call(with: input)
    }
    
    func testResponse() {
        // 仮のデータを作ります。
        let item = Item(title: "testItem", pubDate: nil, link: "", guid: "")
        let feed = Feed(url: "", title: "testFeed", link: "", author: "", description: "", image: "")
        let articleList = RssArticleList(feed: feed, items: [item])
        
        let data = try! JSONEncoder().encode(articleList)
        
        // 仮のレスポンスを定義する。
        let response: Response = (
            statusCode: .ok,
            headers: [:],
            payload: data
        )
        
        // GitHubZen.from 関数を呼び出してみる。
        let errorOrArticleList = RssArticleList.from(response: response)
        
        // 結果は、エラーか禅なフレーズのどちらか。
        switch errorOrArticleList {
        case let .left(error):
            // 上の仮のレスポンスであれば、エラーにはならないはず。
            // そういう場合は、XCTFail という関数でこちらにきてしまったことをわかるようにする。
            XCTFail("\(error)")
            
        case let .right(articleList):
            // 上の仮のレスポンスの禅なフレーズをちゃんと読み取れたかどうか検証したい。
            // そういう場合は、XCTAssertEqual という関数で内容があっているかどうかを検証する。
            XCTAssertEqual(articleList.items[0].title, "testItem")
        }
    }
    
    func testRequestAndResopnse() {
        let expectation = self.expectation(description: "API を待つ")
        let rssApiUrl = URL(string: QiitaType().makeJsonUrl(tag: "swift"))!
        // これまでと同じようにリクエストを作成する。
        let input: Input = (
            url: rssApiUrl,
            queries: [],
            headers: [:],
            methodAndPayload: .get
        )
        
        // このリクエストで API を呼び出す。
        // WebAPI.call の結果は、非同期なのでコールバックになるはず。
        // また、コールバックの引数は Output 型（レスポンスありか通信エラー）になるはず。
        // （注: WebAPI.call がコールバックを受け取れるようにするようにあとで修正する）
        WebAPI.call(with: input) { output in
            // サーバーからのレスポンスが帰ってきた。
            
            // Zen API のレスポンスの内容を確認する。
            switch output {
            case let .noResponse(connectionError):
                // もし、通信エラーが起きていたらわかるようにしておく。
                XCTFail("\(connectionError)")
                
                
            case let .hasResponse(response):
                // レスポンスがちゃんときていた場合は、わかりやすいオブジェクトへと
                // 変換してみる。
                let errorOrArticleList = RssArticleList.from(response: response)
                
                // 正しく呼び出せていれば GitHubZen が帰ってくるはずなので、
                // 右側が nil ではなく値が入っていることを確認する。
                XCTAssertNotNil(errorOrArticleList.right)
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 10)
    }
}
