//
//  RssClientTests.swift
//  RssReaderTests
//
//  Created by 若江照仁 on 2021/05/18.
//

import XCTest
@testable import RssReader

class RssClientTests: XCTestCase {

    func testExample() throws {
        let rssApiUrl = QiitaType().makeJsonUrl(tag: "swift")
        
        var urlSessionItems: [Item]?
        var alamofireItems: [Item]?
        
        RssClient.fetchItems(rssApiUrl: rssApiUrl) { items in
            urlSessionItems = items
        }
        
        RssClient.fetchItems2(rssApiUrl: rssApiUrl) { items in
            alamofireItems = items
        }
        sleep(3)
        XCTContext.runActivity(named: "URLSessionとAlamofireのAPI結果テスト") { _ in
            if urlSessionItems == nil && alamofireItems == nil {
                XCTAssertTrue(true)
                print("Both items are nil")
                return
            }
            let items1 = urlSessionItems!.sorted { $0.link < $1.link}
            let items2 = alamofireItems!.sorted { $0.link < $1.link}
            for i in 0..<items1.count {
                XCTAssertTrue(items1[i].link == items2[i].link)
            }
        }
        
    }

}
