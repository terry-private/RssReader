//
//  YahooType.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/13.
//

import Foundation

class YahooType: RssFeedTypeProtocol {
    let title: String = "Yahoo!ニュース"
    let faviconUrl: String = "https://s.yimg.jp/c/icon/s/bsc/2.0/favicon.ico"
    func makeRssFeed(tag: Any) -> RssFeedProtocol? {
        guard let tagYahooTag = tag as? YahooTag else { return nil }
        return RssFeed(title: title,tag: tagYahooTag.name, url: tagYahooTag.url, faviconUrl: faviconUrl)
    }
    func toSelectTag<T>(view: T) where T : SelectRssFeedDelegate, T : Transitioner {
        CommonRouter.toSelectYahooTagView(view: view)
    }
}

