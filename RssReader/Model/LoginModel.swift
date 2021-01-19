//
//  LoginModel.swift
//  RssReader
//
//  Created by 若江照仁 on 2020/12/26.
//

import Foundation
import Firebase


/// 認証結果をVCに渡します。
protocol AutoLoginDelegate: AnyObject {
    func didAutoLogin(isSuccess: Bool)
}

protocol LoginProtocol {
    var userConfig: UserConfigProtocol {get set}
    var autoLoginDelegate: AutoLoginDelegate? {get set}
    func autoLogin()
    func setUserConfig(userID: String, photoURL: URL?, displayName: String)
}

final class LoginModel: LoginProtocol {
    var userConfig: UserConfigProtocol
    weak var autoLoginDelegate: AutoLoginDelegate?
    
    init(userConfig: UserConfigProtocol) {
        self.userConfig = userConfig
    }
    
    func autoLogin() {
        // 前回の認証が一週間以内の場合のみオートログイン成功と判定します。
        if let latestDate = userConfig.latestLoginDate {
            if latestDate.addingTimeInterval(60 * 60 * 24 * 7) > Date() {
                autoLoginDelegate?.didAutoLogin(isSuccess: true)
                return
            }
        }
        autoLoginDelegate?.didAutoLogin(isSuccess: false)
    }

    func setUserConfig(userID: String, photoURL: URL?, displayName: String) {
        userConfig.userID = userID
        userConfig.photoURL = photoURL
        userConfig.displayName = displayName
        userConfig.latestLoginDate = Date()
    }

}
