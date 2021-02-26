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

protocol FilterModelProtocol {
    var containRead: Bool { get set }
    var pubDateAfter: Int { get set }
    var sortType: SortType { get set }
    var orderByDesc: Bool { get set }
    
}

extension FilterModelProtocol {
    func sort(articleList: [String: Article]) -> [String] {
        var sortedList: [String: Article] = [:]
        for key in articleList.keys {
            guard let article = articleList[key] else { continue }
            if !containRead && article.read { continue }
            if !CommonData.rssFeedListModel.rssFeedList[article.rssFeedUrl]!.display { continue }
            if let pubDateString = article.item.pubDate {
                let pubDate = Date(string: pubDateString)
                if pubDate < Date().addingTimeInterval(TimeInterval(-60 * 60 * 24 * pubDateAfter)) {
                    continue
                }
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
}

class FilterModel: FilterModelProtocol {
    var containRead: Bool = true
    var pubDateAfter: Int = 3
    var sortType: SortType = .rssFeedType
    var orderByDesc: Bool = true
}
