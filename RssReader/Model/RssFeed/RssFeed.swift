//
//  RssFeed.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/13.
//

import Foundation
import RealmSwift

protocol RssFeedTypeProtocol {
    var title: String { get }
    var faviconUrl: String { get }
    func makeRssFeed(tag: Any) -> RssFeedProtocol?
    func toSelectTag<T>(view: T) where T: Transitioner, T: SelectRssFeedDelegate
}

protocol RssFeedProtocol {
    var title: String { get }
    var tag: String { get }
    var url: String { get }
    var display: Bool { get set }
    var faviconUrl: String { get }
    func fetchArticle(completion: @escaping ([String: Article]?) -> Void)
}

class RssFeed: Object {
    @objc dynamic var _title: String = ""
    @objc dynamic private var _tag: String = ""
    @objc dynamic private var _url: String = ""
    @objc dynamic private var _faviconUrl: String = ""
    @objc dynamic private var _display: Bool = true
    convenience init(title: String, tag: String, url: String, faviconUrl: String) {
        self.init()
        _title = title
        _tag = tag
        _url = url
        _faviconUrl = faviconUrl
    }
    override static func primaryKey() -> String? {
        return "_url"
    }
}

extension RssFeed: RssFeedProtocol {
    var title: String {
        get {
            return _title
        }
    }
    var tag: String {
        get {
            return _tag
        }
    }
    var url: String {
        get {
            return _url
        }
    }
    var faviconUrl: String {
        get {
            return _faviconUrl
        }
    }
    var display: Bool {
        get {
            return _display
        }
        set {
            let realm = RealmManager.realm
            try! realm.write {
                _display = newValue
            }
        }
    }
    
    // WebAPIおよびRssArticleListリプレイス前のコード
//    func fetchArticle2(completion: @escaping ([String: Article]?) -> Void){
//        // RssClientの別スレッドの処理中にRealmObject(今回はself)にアクセスできないため別名の変数をこの関数内で保持しておきます。
//        let myTag = self.tag
//        let myTitle = self.title
//        let myUrl = self.url
//        let myFaviconUrl = self.faviconUrl
//        RssClient.fetchItems(rssApiUrl: url) { (response) in
//            var articles: [String: Article] = [:]
//            guard let items = response else {
//                completion(nil)
//                return
//            }
//            for item in items {
//                if !CommonData.rssFeedListModel.articleList.keys.contains(item.link) {
//                    articles[item.link] = Article(item: item, rssFeedTitle: myTitle, rssFeedUrl: myUrl, rssFeedFaviconUrl: myFaviconUrl, tag: myTag)
//                }
//            }
//            completion(articles)
//        }
//    }
    
    /// WebAPI, RssArticleListを使った実装です。
    func fetchArticle(completion: @escaping ([String: Article]?) -> Void){
        let myTag = self.tag
        let myTitle = self.title
        let myUrl = self.url
        let myFaviconUrl = self.faviconUrl
        RssArticleList.fetch(urlString: url) { (errorOrArticle) in
            switch errorOrArticle {
            case let .left(error):
                print(error)
                completion(nil)
            case let .right(articleList):
                var articles: [String: Article] = [:]
                for item in articleList.items {
                    if !CommonData.rssFeedListModel.articleList.keys.contains(item.link) {
                        articles[item.link] = Article(item: item, rssFeedTitle: myTitle, rssFeedUrl: myUrl, rssFeedFaviconUrl: myFaviconUrl, tag: myTag)
                    }
                }
                completion(articles)
            }
        }
    }
}
