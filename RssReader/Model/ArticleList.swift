//
//  ArticleList.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/01/20.
//

import Foundation

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
    let rssFeedFaviconUrl: String
    let tag: String
}
