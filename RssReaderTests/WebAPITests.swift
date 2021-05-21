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
    
    func testResopnse() {
        // 仮のレスポンスを定義する。
        let response: Response = (
            statusCode: .ok,
            headers: [:],
            payload: "this is a response text".data(using: .utf8)!
        )
        
        // GitHubZen.from 関数を呼び出してみる。
        let errorOrArticle = RssArticle.from(response: response)
        
        // 結果は、エラーか禅なフレーズのどちらか。
        switch errorOrArticle {
        case let .left(error):
            // 上の仮のレスポンスであれば、エラーにはならないはず。
            // そういう場合は、XCTFail という関数でこちらにきてしまったことをわかるようにする。
            XCTFail("\(error)")
            
        case let .right(article):
            // 上の仮のレスポンスの禅なフレーズをちゃんと読み取れたかどうか検証したい。
            // そういう場合は、XCTAssertEqual という関数で内容があっているかどうかを検証する。
            XCTAssertEqual(article.item.title, "this is a response text")
        }
    }
}
