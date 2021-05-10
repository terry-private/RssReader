//
//  ArticleList.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/01/20.
//

import Foundation
import RealmSwift

struct ArticleList: Codable {
    let feed: Feed
    let items: [Item]
}

struct Feed: Codable {
    let url: String
    let title: String
    let link: String
    let author: String
    let description: String
    let image: String
}

struct Item: Codable {
    let title: String
    let pubDate: String? // YahooNewsにpugDateがnullのものが混じってたのでnullを受け入れられるようにOptional型に変更しておきます。
    let link: String
    let guid: String
}

struct Article {
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

class RealmArticle: Object {
    // Itemの関連プロパティ
    @objc dynamic var title: String!
    @objc dynamic var pubDate: String?
    @objc dynamic var link: String!
    @objc dynamic var guid: String!
    override static func primaryKey() -> String? {
        return "link"
    }
    // Articleの関連プロパティ
    @objc dynamic var rssFeedTitle: String!
    @objc dynamic var rssFeedUrl: String!
    @objc dynamic var rssFeedFaviconUrl: String!
    @objc dynamic var tag: String!
    @objc dynamic var read: Bool = false
    @objc dynamic var laterRead: Bool = false
    @objc dynamic var isStar: Bool = false
    convenience init(article: Article) {
        self.init()
        title = article.item.title
        pubDate = article.item.pubDate
        link = article.item.link
        guid = article.item.guid
        
        rssFeedTitle = article.rssFeedTitle
        rssFeedUrl = article.rssFeedUrl
        rssFeedFaviconUrl = article.rssFeedFaviconUrl
        tag = article.tag
    }
    
}
