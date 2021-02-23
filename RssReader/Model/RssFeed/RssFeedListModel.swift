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
    var rssFeedListModelDelegate: RssFeedListModelDelegate? { get set}
    func fetchItems(rssFeedListModelDelegate: RssFeedListModelDelegate)
}

class RssFeedListModel: RssFeedListModelProtocol {
    var typeList: [RssFeedTypeProtocol] = []
    var rssFeedList: [String: RssFeedProtocol] = [:]
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
}
