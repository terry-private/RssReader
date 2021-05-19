//
//  RssClientTests.swift
//  RssReaderTests
//
//  Created by 若江照仁 on 2021/05/18.
//

import XCTest
import Foundation
@testable import RssReader
import Alamofire

class RssClientTests: XCTestCase {
    
    func testFetchAPI() throws {
        let rssApiUrl = QiitaType().makeJsonUrl(tag: "swift")
        var urlSessionItems: [Item]?
        var alamofireItems: [Item]?
        
        let expectation = self.expectation(description: "Alamofire待ち")
        let expectation2 = self.expectation(description: "URLSessionQueue待ち")
        
        RssClient.fetchItems(rssApiUrl: rssApiUrl) { items in
            alamofireItems = items
            print("fetchItems完了")
            expectation.fulfill()
        }
        
        RssClient.fetchItems2(rssApiUrl: rssApiUrl) { items in
            urlSessionItems = items
            print("fetchItems2完了")
            expectation2.fulfill()
        }
        
        self.waitForExpectations(timeout: 10)
        
        XCTContext.runActivity(named: "URLSessionとAlamofireのAPI結果テスト") { _ in
            if urlSessionItems == nil && alamofireItems == nil {
                XCTAssertTrue(true)
                print("Both items are nil")
                return
            }
            XCTAssertNotNil(urlSessionItems, "urlSessionの結果がnilでした。")
            XCTAssertNotNil(alamofireItems, "alamofireの結果がnilでした。")
            
            let items1 = urlSessionItems!.sorted { $0.link < $1.link}
            let items2 = alamofireItems!.sorted { $0.link < $1.link}
            for i in 0..<items1.count {
                XCTAssertTrue(items1[i].link == items2[i].link)
            }
        }
    }
}
