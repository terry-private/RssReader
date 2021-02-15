//
//  YahooType.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/13.
//

import Foundation

class YahooType: RssFeedTypeProtocol {
    let title: String = "Yahoo!"
    let faviconUrl: String = "https://s.yimg.jp/c/icon/s/bsc/2.0/favicon.ico"
    func makeRssFeed(tag: Any) -> RssFeedProtocol? {
        guard let tagYahooTag = tag as? YahooTag else { return nil }
        return RssFeed(title: "Yahoo",tag: tagYahooTag.name, url: tagYahooTag.url, faviconUrl: faviconUrl)
    }
}

