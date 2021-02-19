//
//  QiitaType.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/13.
//

import Foundation

class QiitaType: RssFeedTypeProtocol {
    let title: String = "Qiita"
    let faviconUrl: String = "https://cdn.qiita.com/assets/favicons/public/production-c620d3e403342b1022967ba5e3db1aaa.ico"
    func makeRssFeed(tag: Any) -> RssFeedProtocol? {
        guard let tagString = tag as? String else { return nil }
        return RssFeed(title: title, tag: tagString, url: "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fqiita.com%2Ftags%2F\(tag)%2Ffeed", faviconUrl: faviconUrl)
    }
}
