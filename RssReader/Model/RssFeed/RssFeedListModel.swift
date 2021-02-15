//
//  RssFeedListModel.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/14.
//

import Foundation

protocol RssFeedListModelDelegate: AnyObject {
    func loaded(articleList: [String: Article])
}

protocol RssFeedListModelProtocol {
    var typeList: [RssFeedTypeProtocol] { get set }
    var rssFeedList: [RssFeedProtocol] { get set }
    var articleList: [String: Article] { get set }
    var loadCounter: Int { get set }
    var rssFeedListModelDelegate: RssFeedListModelDelegate? { get set}
    func fetchItems()
}

class RssFeedListModel: RssFeedListModelProtocol {
    var typeList: [RssFeedTypeProtocol] = []
    var rssFeedList: [RssFeedProtocol] = []
    var articleList: [String: Article] = [:]
    
    var loadCounter: Int = 0 {
        didSet {
            if loadCounter == 0 {
                rssFeedListModelDelegate?.loaded(articleList: articleList)
            }
        }
    }
    
    weak var rssFeedListModelDelegate: RssFeedListModelDelegate?
    
    /// rssFeedを一つずつ読み込んでいく
    /// すべてfetchしたかどうかはloadCounterで管理します。
    /// 待ち合わせの仕方がわからないので一旦この方法で進めます。
    func fetchItems() {
        loadCounter = rssFeedList.count
        for rssFeed in rssFeedList {
            rssFeed.fetchArticle { (articles) in
                if let articleList = articles {
                    self.articleList += articleList
                }
                self.loadCounter -= 1
            }
        }
    }
}
