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
            // ステータスコードは 200 OK なはず。
            statusCode: .ok,
            
            // 読み取るべきヘッダーは特にない。
            headers: [:],
            
            // Zen API のレスポンスは、禅なフレーズの文字列。
            payload: "this is a response text".data(using: .utf8)!
        )
        
        // TODO: このままだとペイロードが Data になってしまっていて使いづらいので、
        // よりわかりやすいレスポンスのオブジェクトへと変換する。
    }
}
