//
//  FilterModel.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/24.
//

import Foundation

enum SortType: CaseIterable {
    case pubDate
    case rssFeedType
    var name: String {
        switch self {
        case .pubDate:
            return "発刊日順"
        case .rssFeedType:
            return "記事タイプ順"
        }
    }
    var index: Int {
        switch self {
        case .pubDate:
            return 0
        default:
            return 1
        }
    }
}

enum DisplayMode: CaseIterable {
    case tableMode
    case collectionMode
    var index: Int {
        switch self {
        case .tableMode:
            return 0
        case .collectionMode:
            return 1
        }
    }
}

protocol FilterModelProtocol {
    var containRead: Bool { get set }
    var pubDateAfter: Int { get set }
    var sortType: SortType { get set }
    var orderByDesc: Bool { get set }
    var fetchTimeInterval: Int { get set}
    var displayMode: DisplayMode { get set }
}

extension FilterModelProtocol {
    private func sort(articleList: [String: Article]) -> [String] {
        var sortedList: [String: Article] = [:]
        for key in articleList.keys {
            guard let article = articleList[key] else { continue }
            if !containRead && article.read { continue }
            
            // 購読RssFeedに登録されている記事なのに表示モードがオフの場合だけ飛ばします。
            if let rssFeed = CommonData.rssFeedListModel.rssFeedList[article.rssFeedUrl] {
                if !rssFeed.display { continue }
            }
            sortedList[key] = article
        }
        switch sortType {
        case .pubDate:
            if orderByDesc {
                return sortedList.sorted { $0.value.item.pubDate! > $1.value.item.pubDate! } .map { $0.key }
            } else {
                return sortedList.sorted { $0.value.item.pubDate! < $1.value.item.pubDate! } .map { $0.key }
            }
        case .rssFeedType:
            if orderByDesc {
                return sortedList.keys.sorted { $0 > $1}
            } else {
                return sortedList.keys.sorted { $0 < $1}
            }
        }
    }
    func sortMainList(articleList: [String: Article]) -> [String] {
        var mainList: [String: Article] = [:]
        for article in articleList.values {
            if article.laterRead { continue }
            if let pubDateString = article.item.pubDate {
                let pubDate = Date(string: pubDateString)
                if pubDate < Date().addingTimeInterval(TimeInterval(-60 * 60 * 24 * pubDateAfter)) {
                    continue
                }
            }
            mainList[article.item.link] = article
        }
        return sort(articleList: mainList)
    }
    func sortStarList(articleList: [String: Article]) -> [String] {
        var starList: [String: Article] = [:]
        for article in articleList.values {
            if article.isStar {
                starList[article.item.link] = article
            }
        }
        return sort(articleList: starList)
    }
    func sortLaterReadList(articleList: [String: Article]) -> [String] {
        var laterReadList: [String: Article] = [:]
        for article in articleList.values {
            if article.laterRead {
                laterReadList[article.item.link] = article
            }
        }
        return sort(articleList: laterReadList)
    }
}

class FilterModel: FilterModelProtocol {
    var containRead: Bool = true
    var pubDateAfter: Int = 3
    var sortType: SortType = .rssFeedType
    var orderByDesc: Bool = true
    /// 分
    var fetchTimeInterval: Int = 1
    
    /// 表示モード
    var displayMode: DisplayMode = .collectionMode
}
