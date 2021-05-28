//
//  HotpepperAPITests.swift
//  RssReaderTests
//
//  Created by 若江照仁 on 2021/05/28.
//

import XCTest
@testable import RssReader

class HotpepperAPITests: XCTestCase {
    
    func testFetchRestaurants() throws {
        let expectation = self.expectation(description: "API")
        HotpepperAPI.fetchRestaurants(latitude: 34.7699858, longitude: 135.4131484) { errorOrRestaurants in
            // エラーかレスポンスがきたらコールバックが実行されて欲しい。
            // できれば、結果はすでに変換済みの RssArticleList オブジェクトを受け取りたい。
            
            switch errorOrRestaurants {
            case let .left(error):
                // エラーがきたらわかりやすいようにする。
                XCTFail("\(error)")
                
            case let .right(restaurants):
                // 結果をきちんと受け取れたことを確認する。
                XCTAssertNotNil(restaurants)
                print(restaurants[0].name)
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 10)
    }

}
