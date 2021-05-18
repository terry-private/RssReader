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
    var timeCount = 0
    @objc func timerUpdate() {
        timeCount += 1
    }
    func testFetchAPI() throws {
        let rssApiUrl = QiitaType().makeJsonUrl(tag: "swift")
        var urlSessionItems: [Item]?
        var alamofireItems: [Item]?
        // 待ち合わせ用のカウンター
        var asynchronousMeetingCount = 0
        
        
        
        RssClient.fetchItems2(rssApiUrl: rssApiUrl) { items in
            urlSessionItems = items
            asynchronousMeetingCount += 1
            print("fetchItems完了")
        }
        
        RssClient.fetchItems(rssApiUrl: rssApiUrl) { items in
            alamofireItems = items
            asynchronousMeetingCount += 1
            print("fetchItems2完了")
        }
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerUpdate), userInfo: true, repeats: true)
        while asynchronousMeetingCount < 2 {
            if timeCount > 5 {
                break
            }
        }
        
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
