//
//  YahooType.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/13.
//

import Foundation

class YahooType: RssFeedTypeProtocol {
    let title: String = "Yahoo"
    let faviconUrl: String = "http://www.google.com/s2/favicons?domain=www.yahoo.co.jp"
    func makeRssFeed(tag: Any) -> RssFeed? {
        guard let tagYahooTag = tag as? YahooTag else { return nil }
        return RssFeed(title: "Yahoo",tag: tagYahooTag.name, url: tagYahooTag.url, faviconUrl: faviconUrl)
    }
}
