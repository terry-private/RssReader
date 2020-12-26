//
//  AutoLoginModel.swift
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

protocol AutoLoginProtocol {
    var userConfig: UserConfigProtocol {get set}
    var delegate: AutoLoginDelegate? {get set}
    func autoLogin()
}


final class AutoLoginModel: AutoLoginProtocol {
    var userConfig: UserConfigProtocol
    weak var delegate: AutoLoginDelegate?
    
    init(userConfig: UserConfigProtocol) {
        self.userConfig = userConfig
    }
    
    func autoLogin() {
        var isSuccess = false
        // FireAuthの認証ができない　かつ
        // 前回の認証が一週間以上前の場合にオートログイン失敗と判定します。
        if let user = Auth.auth().currentUser {
            userConfig.userID = user.uid
            userConfig.displayName = user.displayName
            userConfig.photoURL = user.photoURL
            userConfig.latestLoginDate = Date()
            isSuccess = true
        } else {
            if let latestDate = userConfig.latestLoginDate {
                if latestDate.addingTimeInterval(60 * 60 * 24 * 7) > Date() {
                    isSuccess = true
                }
            }
        }
        delegate?.didAutoLogin(isSuccess: isSuccess)
    }
    
}
