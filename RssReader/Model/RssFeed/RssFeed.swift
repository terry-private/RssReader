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
    func makeRssFeed(tag: Any) -> RssFeedProtocol?
}

protocol RssFeedProtocol {
    var title: String { get }
    var tag: String { get }
    var url: String { get }
    var faviconUrl: String { get }
    func fetchArticle(completion: @escaping ([String: Article]?) -> Void)
}

class RssFeed: RssFeedProtocol {
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
    func fetchArticle(completion: @escaping ([String: Article]?) -> Void){
        RssClient.fetchItems(rssApiUrl: url) { (response) in
            var articles: [String: Article] = [:]
            guard let items = response else {
                completion(nil)
                return
            }
            for item in items {
                articles[item.link] = Article(item: item, rssFeedTitle: self.title, rssFeedFaviconUrl: self.faviconUrl, tag: self.tag)
            }
            completion(articles)
        }
    }
}
