//
//  DummyModel.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/01/05.
//

import Foundation



class DummyUserConfig: UserConfigProtocol {
    var userID: String? = "dummyId"
    var photoURL: URL? = nil
    var displayName: String? = "dummyName"
    var latestLoginDate: Date? = Date()
    func removeUser() {
        userID = nil
        photoURL = nil
        displayName = nil
        latestLoginDate = nil
    }
}



/// 必ずオートログインに失敗するやつです。
class DummyLoginModel: LoginProtocol {
    func toLogoutAlert<T>(view: T) where T : LogoutDelegate, T : Transitioner {
        // ダミーでログアウトの動きを確認するようのコードです。
        // コメントアウトを外すとタッチでログアウトするのでその後の動きが確認できます。
//        view.didLogout()
    }
    
    var userConfig: UserConfigProtocol
    init() {
        userConfig = DummyUserConfig()
    }
    func autoLogin(autoLoginDelegate: AutoLoginDelegate) {
        autoLoginDelegate.didAutoLogin(isSuccess: true)
    }
    
    func setUserConfig(userID: String, photoURL: URL?, displayName: String) {
        userConfig.userID = userID
        userConfig.photoURL = photoURL
        userConfig.displayName = displayName
        userConfig.latestLoginDate = Date()
    }
}


// MARK:- 重複する処理が多いので本番用のサブクラスにします。
class DummyRssFeedListModel: RssFeedListModel {
    override init() {
        super.init()
        typeList = [QiitaType(), YahooType()]
        if let qiita = QiitaType().makeRssFeed(tag: "swift") {
            rssFeedList[qiita.url] = qiita
        }
        if let yahoo = YahooType().makeRssFeed(tag: YahooTag.informationTechnology) {
            rssFeedList[yahoo.url] = yahoo
        }
    }
    override func changeStar(articleKey: String, isStar: Bool) {
        articleList[articleKey]?.isStar = isStar
    }
    override func changeLaterRead(articleKey: String, laterRead: Bool) {
        articleList[articleKey]?.laterRead = laterRead
    }
    override func changeRead(articleKey: String, read: Bool) {
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
