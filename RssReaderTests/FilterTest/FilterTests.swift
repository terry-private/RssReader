//
//  FilterTests.swift
//  RssReaderTests
//
//  Created by 若江照仁 on 2022/03/20.
//

import XCTest
@testable import RssReader

class FilterTests: XCTestCase {
    var testCounter = 1
    
    private func createItem(key: String, pubDate: String) -> Item {
        return Item(
            title: "title" + key,
            pubDate: pubDate,
            link: "link" + key,
            guid: "guid" + key
        )
    }
    private func createArticle(key: String, pubDate: String, rssFeedTitle: String, read: Bool = false, laterRead: Bool = false, isStar: Bool = false) -> Article {
        return Article(
            item: createItem(key: key, pubDate: pubDate),
            rssFeedTitle: rssFeedTitle,
            rssFeedUrl: "rssFeedUrl" + key,
            rssFeedFaviconUrl: "rssFeedFaviconUrl" + key,
            tag: "tag",
            read: read,
            laterRead: laterRead,
            isStar: isStar
        )
    }

    func testSort() throws {
        let date1 = Date.current().pubDateString
        let date2 = Date.current().addingTimeInterval(-60*60*24).pubDateString
        let date3 = Date.current().addingTimeInterval(-60*60*24*2).pubDateString
        let date4 = Date.current().addingTimeInterval(-60*60*24*3).pubDateString
        let date5 = Date.current().addingTimeInterval(-60*60*24*4).pubDateString
        let date6 = Date.current().addingTimeInterval(-60*60*24*5).pubDateString
        var articleList = [
            "1": createArticle(key: "1", pubDate: date1, rssFeedTitle: "Qiita"),
            "2": createArticle(key: "2", pubDate: date2, rssFeedTitle: "Yahoo"),
            "3": createArticle(key: "3", pubDate: date3, rssFeedTitle: "Qiita"),
            "4": createArticle(key: "4", pubDate: date4, rssFeedTitle: "Yahoo", read: true),
            "5": createArticle(key: "5", pubDate: date5, rssFeedTitle: "Qiita", read: true),
            "6": createArticle(key: "6", pubDate: date6, rssFeedTitle: "Yahoo", read: true)
        ]
        // 1~3
        XCTContext.runActivity(named: "test_\(testCounter)~\(testCounter+2) containRead = false で read = falseの記事のみ表示されているかどうか") { _ in
            let filterModel = FilterModel()
            filterModel.pubDateAfter = 6
            filterModel.containRead = false
            filterModel.sortType = .pubDate
            
            let results = filterModel.sortMainList(articleList: articleList)
            for i in 1...results.count {
                XCTAssertTrue(results.contains("link\(i)"))
                testCounter+=1
            }
        }
        
        // 4~9
        XCTContext.runActivity(named: "test_\(testCounter)~\(testCounter+5) containRead = true で　read = trueの記事も表示されているかどうか") { _ in
            let filterModel = FilterModel()
            filterModel.pubDateAfter = 6
            filterModel.containRead = true
            filterModel.sortType = .pubDate
            
            let results = filterModel.sortMainList(articleList: articleList)
            for i in 1...results.count {
                XCTAssertTrue(results.contains("link\(i)"))
                testCounter+=1
            }
        }
        
        // 10~15
        XCTContext.runActivity(named: "test_\(testCounter)~\(testCounter+5) sortTypeが.pubDate, orderByDesc == trueの時に日付降順になっているかどうか") { _ in
            let filterModel = FilterModel()
            filterModel.pubDateAfter = 6
            filterModel.containRead = true
            filterModel.sortType = .pubDate
            filterModel.orderByDesc = true
            
            let results = filterModel.sortMainList(articleList: articleList)
            for i in 1...results.count {
                XCTAssertEqual(results[i-1] , "link\(i)")
                testCounter+=1
            }
        }
        // 16~21
        XCTContext.runActivity(named: "test_\(testCounter)~\(testCounter+5) sortTypeが.pubDate, orderByDesc == falseの時に日付昇順になっているかどうか") { _ in
            let filterModel = FilterModel()
            filterModel.pubDateAfter = 6
            filterModel.containRead = true
            filterModel.sortType = .pubDate
            filterModel.orderByDesc = false
            
            let results = filterModel.sortMainList(articleList: articleList)
            for i in 1...results.count {
                XCTAssertEqual(results[i-1] , "link\(7-i)")
                testCounter+=1
            }
        }
        
        // 22~27
        XCTContext.runActivity(named: "test_\(testCounter)~\(testCounter+5) sortTypeが.pubDate, orderByDesc == falseの時に日付昇順になっているかどうか") { _ in
            let filterModel = FilterModel()
            filterModel.pubDateAfter = 6
            filterModel.containRead = true
            filterModel.sortType = .rssFeedType
            filterModel.orderByDesc = true
            
            let results = filterModel.sortMainList(articleList: articleList)
            for i in 1...results.count {
                XCTAssertEqual(results[i-1] , "link\((i*2)%7)") // 2,4,6,1,3,5
                testCounter+=1
            }
        }
        // 28~33
        XCTContext.runActivity(named: "test_\(testCounter)~\(testCounter+5) sortTypeが.rssFeedType, orderByDesc == falseの時にRssFeedTypeごとの日付昇順になっているかどうか") { _ in
            let filterModel = FilterModel()
            filterModel.pubDateAfter = 6
            filterModel.containRead = true
            filterModel.sortType = .rssFeedType
            filterModel.orderByDesc = false
            
            let results = filterModel.sortMainList(articleList: articleList)
            for i in 1...results.count {
                XCTAssertEqual(results[i-1] , "link\(7-(i*2)%7)") // 5,3,1,6,4,2
                testCounter+=1
            }
        }
        
        // 34
        XCTContext.runActivity(named: "test_\(testCounter) pubDateがpubDateAfterを過ぎたArticleがスキップされているかどうか") { _ in
            let filterModel = FilterModel()
            filterModel.pubDateAfter = 1
            filterModel.containRead = false
            filterModel.sortType = .pubDate
            
            let results = filterModel.sortMainList(articleList: articleList)
            XCTAssertEqual(results, ["link1"])
            testCounter += 1
        }
        
        // 35
        XCTContext.runActivity(named: "test_\(testCounter) isStarのみかどうか") { _ in
            let filterModel = FilterModel()
            filterModel.pubDateAfter = 6
            filterModel.containRead = false
            filterModel.sortType = .pubDate
            articleList["1"]?.isStar = true
            let results = filterModel.sortStarList(articleList: articleList)
            XCTAssertEqual(results, ["link1"])
            testCounter += 1
        }
        
        // 36
        XCTContext.runActivity(named: "test_\(testCounter) laterReadのみかどうか") { _ in
            let filterModel = FilterModel()
            filterModel.pubDateAfter = 6
            filterModel.containRead = false
            filterModel.sortType = .pubDate
            articleList["1"]?.laterRead = true
            
            let results = filterModel.sortLaterReadList(articleList: articleList)
            XCTAssertEqual(results, ["link1"])
            testCounter += 1
        }
        
    }

}

private let pubDateFormatter = DateFormatter.pubDateFormatter()
private extension Date {
    var pubDateString: String {
        pubDateFormatter.string(from: self)
    }
}
