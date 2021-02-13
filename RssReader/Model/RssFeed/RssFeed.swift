//
//  RssFeed.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/13.
//

import Foundation

protocol RssFeedTypeProtocol {
    var title: String { get }
    var faviconUrl: String { get }
    func makeRssFeed(tag: Any) -> RssFeed?
}

class RssFeed {
    let title: String
    let tag: String
    let url: String
    let faviconUrl: String
    init(title: String, tag: String, url: String, faviconUrl: String) {
        self.title = title
        self.tag = tag
        self.url = url
        self.faviconUrl = faviconUrl
    }
    func fetchArticle(completion: @escaping ([Item]?) -> Void){
        RssClient.fetchItems(rssApiUrl: url) { (response) in
            completion(response)
        }
    }
}
