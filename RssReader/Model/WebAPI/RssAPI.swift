//
//  RssAPI.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/05/21.
//

import Foundation

/// 既存のArticleList, Feed, Itemは利用して
/// Articleを書き換えます。一旦コピーします。
struct RssArticle {
    let item: Item
    let rssFeedTitle: String
    let rssFeedUrl: String
    let rssFeedFaviconUrl: String
    let tag: String
    var read: Bool = false
    var laterRead: Bool = false
    var isStar: Bool = false
    var sortKey: String {
        return rssFeedTitle + tag + (item.pubDate?.description ?? "") + item.link
    }
}
