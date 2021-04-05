//
//  DummyModel.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/01/05.
//

import Foundation



class DummyUserConfig: UserConfigProtocol {
    var loginType: String? = "dummy"
    var userID: String? = nil
    var password: String? = nil
    var photoURL: URL? = nil
    var displayName: String? = nil
    var latestLoginDate: Date? = nil
    func removeUser() {
        userID = nil
        photoURL = nil
        displayName = nil
        latestLoginDate = nil
    }
}



/// 必ずオートログインに失敗するやつです。
class DummyLoginModel: LoginProtocol {
    
    var userConfig: UserConfigProtocol
    init() {
        userConfig = DummyUserConfig()
    }
    func autoLogin(autoLoginDelegate: AutoLoginDelegate) {
        autoLoginDelegate.didAutoLogin(isSuccess: false)
    }
    
    func setUserConfig(userID: String, photoURL: URL?, displayName: String) {
        userConfig.userID = userID
        userConfig.photoURL = photoURL
        userConfig.displayName = displayName
        userConfig.latestLoginDate = Date()
    }
}


// MARK:- 重複する処理が多いので本番用のサブクラスにします。
class DummyRssFeedListModel: RssFeedListModelProtocol {
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
    private func refreshArticleList() {
        let articleListValues = articleList.values
        let rssFeedListKeys = rssFeedList.keys
        for article in articleListValues {
            if  !rssFeedListKeys.contains(article.rssFeedUrl) && !article.isStar && !article.laterRead{
                articleList.removeValue(forKey: article.item.link)
            }
        }
    }
    
    init() {
        typeList = [QiitaType(), YahooType()]
    }
    var typeList: [RssFeedTypeProtocol] = [QiitaType(), YahooType()]
    var rssFeedList = [String: RssFeedProtocol]()
    var articleList = [String: Article]()
    func changeStar(articleKey: String, isStar: Bool) {
        articleList[articleKey]?.isStar = isStar
    }
    func changeLaterRead(articleKey: String, laterRead: Bool) {
        articleList[articleKey]?.laterRead = laterRead
    }
    func changeRead(articleKey: String, read: Bool) {
        articleList[articleKey]?.read = read
    }
}

class DummyFilterModel: FilterModelProtocol {
    var containRead: Bool = true
    var pubDateAfter: Int = 3
    var sortType: SortType = .rssFeedType
    var orderByDesc: Bool = true
    var rssFeedListKeys: [String] = []
    var fetchTimeInterval = 1
    var displayMode: DisplayMode = .tableMode
}
