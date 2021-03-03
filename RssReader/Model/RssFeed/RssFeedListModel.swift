//
//  RssFeedListModel.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/14.
//

import Foundation
import RealmSwift

protocol RssFeedListModelDelegate: AnyObject {
    func loaded()
}

protocol RssFeedListModelProtocol {
    var typeList: [RssFeedTypeProtocol] { get set }
    var rssFeedList: [String: RssFeedProtocol] { get set }
    var articleList: [String: Article] { get set }
    func fetchItems(rssFeedListModelDelegate: RssFeedListModelDelegate)
    func changeStar(articleKey: String, isStar: Bool)
    func changeLaterRead(articleKey: String, laterRead: Bool)
    func changeRead(articleKey: String, read: Bool)
}


class RssFeedListModel: RssFeedListModelProtocol {
    var typeList: [RssFeedTypeProtocol] = [QiitaType(), YahooType()]
    var rssFeedList: [String: RssFeedProtocol] {
        get {
            let realm = try! Realm()
            var rssFeeds = [String: RssFeedProtocol]()
            let realmRssFeeds = realm.objects(RssFeed.self)
            for rssFeed in realmRssFeeds {
                rssFeeds[rssFeed.url] = rssFeed
            }
            return rssFeeds
        }
        set {
            let realm = try! Realm()
            let results = realm.objects(RssFeed.self)
            // newValueにない元々のRssFeedを消す動作をするのと同時に
            // 元々あるRssFeedは重複してaddしないように重複リストを作成します。
            var duplicatedKeys = [String]()
            
            for result in results {
                if newValue.keys.contains(result.url) {
                    duplicatedKeys.append(result.url)
                } else {
                    try! realm.write{
                        realm.delete(result)
                    }
                }
            }
            let newValues = newValue.values
            for rssFeed in newValues {
                // 重複リストになければ追加します。
                if !duplicatedKeys.contains(rssFeed.url) {
                    try! realm.write{
                        realm.add(rssFeed as! RssFeed)
                    }
                }
            }
            
        }
    }
    var articleList: [String: Article] {
        get {
            let realm = try! Realm()
            let realmArticles = realm.objects(RealmArticle.self)
            var articles = [String: Article]()
            for realmArticle in realmArticles {
                var article = Article(item: Item(title: realmArticle.title, pubDate: realmArticle.pubDate, link: realmArticle.link, guid: realmArticle.guid), rssFeedTitle: realmArticle.rssFeedTitle, rssFeedUrl: realmArticle.rssFeedUrl, rssFeedFaviconUrl: realmArticle.rssFeedFaviconUrl, tag: realmArticle.tag)
                article.isStar = realmArticle.isStar
                article.laterRead = realmArticle.laterRead
                article.read = realmArticle.read
                articles[realmArticle.link] = article
            }
            return articles
        }
        set {
            let realm = try! Realm()
            let realmArticles = realm.objects(RealmArticle.self)
            // newValueにない元々のRssFeedを消す動作をするのと同時に
            // 元々あるRssFeedは重複してaddしないように重複リストを作成します。
            var duplicatedKeys = [String]()
            
            for realmArticle in realmArticles {
                if newValue.keys.contains(realmArticle.link) {
                    duplicatedKeys.append(realmArticle.link)
                } else {
                    try! realm.write{
                        realm.delete(realmArticle)
                    }
                }
            }
            let newValues = newValue.values
            for article in newValues {
                // 重複リストになければ追加します。
                if !duplicatedKeys.contains(article.item.link) {
                    try! realm.write{
                        realm.add(RealmArticle(article: article))
                    }
                }
            }
        }
    }
    var loadCounter: Int = 0 {
        didSet {
            if loadCounter == 0 {
                rssFeedListModelDelegate?.loaded()
            }
        }
    }
    
    internal weak var rssFeedListModelDelegate: RssFeedListModelDelegate?
    
    /// rssFeedを一つずつ読み込んでいく
    /// すべてfetchしたかどうかはloadCounterで管理します。
    /// 待ち合わせの仕方がわからないので一旦この方法で進めます。
    func fetchItems(rssFeedListModelDelegate: RssFeedListModelDelegate) {
        refreshArticleList()// いらない記事を先に消しておきます。
        self.rssFeedListModelDelegate = rssFeedListModelDelegate
        loadCounter = rssFeedList.count
        let rssFeeds = rssFeedList
        for key in rssFeeds.keys {
            rssFeeds[key]!.fetchArticle { (articles) in
                if let articleList = articles {
                    self.articleList += articleList // extensionで辞書の足し算をできるようにしてます。
                }
                self.loadCounter -= 1
            }
        }
    }
    
    // RssFeedを削除したときにArticleListからタグ付けされていない記事を削除します。
    // 今後保管済みの記事を扱うなどする場合はここで条件分岐すればいいかと
    func refreshArticleList() {
        let articleListValues = articleList.values
        let rssFeedListKeys = rssFeedList.keys
        for article in articleListValues {
            if  !rssFeedListKeys.contains(article.rssFeedUrl) && !article.isStar && !article.laterRead{
                articleList.removeValue(forKey: article.item.link)
            }
        }
    }
    
    func changeStar(articleKey: String, isStar: Bool) {
        let realm = try! Realm()
        let article = realm.object(ofType: RealmArticle.self, forPrimaryKey: articleKey)
        try! realm.write {
            article?.isStar = isStar
        }
    }
    
    func changeLaterRead(articleKey: String, laterRead: Bool) {
        let realm = try! Realm()
        let article = realm.object(ofType: RealmArticle.self, forPrimaryKey: articleKey)
        try! realm.write {
            article?.laterRead = laterRead
        }
    }
    
    func changeRead(articleKey: String, read: Bool) {
        let realm = try! Realm()
        let article = realm.object(ofType: RealmArticle.self, forPrimaryKey: articleKey)
        try! realm.write {
            article?.read = read
        }
    }
}
