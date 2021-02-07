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
    
    var autoLoginDelegate: AutoLoginDelegate?
    init() {
        userConfig = DummyUserConfig()
    }
    func autoLogin() {
        autoLoginDelegate?.didAutoLogin(isSuccess: true)
    }
    
    func setUserConfig(userID: String, photoURL: URL?, displayName: String) {
        userConfig.userID = userID
        userConfig.photoURL = photoURL
        userConfig.displayName = displayName
        userConfig.latestLoginDate = Date()
    }
}


class DummySelectRFeedModel: SelectRssFeedModelProtocol {
    var selectedRssFeedList: Set<String> = Set<String>()
    
    var rssFeedList: [String] = []
    
    init() {
        for i in 1...50 {
            rssFeedList.append("dummy\(i)")
        }
        selectedRssFeedList.insert("dummy2")
    }
}
