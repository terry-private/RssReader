//
//  RssFeedListModel.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/14.
//

import Foundation

protocol RssFeedListModelDelegate: AnyObject {
    func loaded()
}

protocol RssFeedListModelProtocol {
    var typeList: [RssFeedTypeProtocol] { get set }
    var rssFeedList: [String: RssFeedProtocol] { get set }
    var articleList: [String: Article] { get set }
    var starList: Set<String> { get set }
    var laterReadList: Set<String> { get set }
    func fetchItems(rssFeedListModelDelegate: RssFeedListModelDelegate)
}

class RssFeedListModel: RssFeedListModelProtocol {
    var typeList: [RssFeedTypeProtocol] = []
    var rssFeedList: [String: RssFeedProtocol] = [:] // RssFeed.urlをkeyにしてます。
    var articleList: [String: Article] = [:] // item.linkをkeyにしてます。
    var starList: Set<String> = []
    var laterReadList: Set<String> = []
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
        for rssFeed in rssFeedList.keys {
            rssFeedList[rssFeed]!.fetchArticle { (articles) in
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
        let articleListKeys = articleList.keys
        for key in articleListKeys {
            if  !rssFeedList.keys.contains(articleList[key]!.rssFeedUrl) && !starList.contains(key) && !laterReadList.contains(key){
                articleList.removeValue(forKey: key)
            }
        }
    }
}
