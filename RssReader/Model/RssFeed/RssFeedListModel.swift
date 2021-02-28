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
                print(rssFeed)
            }
            return rssFeeds
        }
        set {
            let realm = try! Realm()
            let results = realm.objects(RssFeed.self)
            // newValueにない元々のRssFeedを消す動作をするのと同時に
            // 元々あるRssFeedは重複してaddしないようにします。
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
                if !duplicatedKeys.contains(rssFeed.url) {
                    try! realm.write{
                        realm.add(rssFeed as! RssFeed)
                    }
                }
            }
            
        }
    }
    var articleList: [String: Article] = [:]
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
}
