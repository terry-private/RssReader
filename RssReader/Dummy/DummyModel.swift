//
//  DummyModel.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/01/05.
//

import Foundation



class DummyUserConfig: UserConfigProtocol {
    var userID: String?
    var photoURL: URL?
    var displayName: String?
    var latestLoginDate: Date?
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
}
