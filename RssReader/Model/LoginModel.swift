//
//  LoginModel.swift
//  RssReader
//
//  Created by 若江照仁 on 2020/12/26.
//

import Foundation
import Firebase
import RealmSwift

/// 認証結果をVCに渡します。
protocol AutoLoginDelegate: AnyObject {
    func didAutoLogin(isSuccess: Bool)
}
protocol LogoutDelegate: AnyObject {
    func didLogout()
}
protocol LoginProtocol {
    var userConfig: UserConfigProtocol {get set}
    func autoLogin(autoLoginDelegate: AutoLoginDelegate)
    func setUserConfig(userID: String, photoURL: URL?, displayName: String)
    func toLogoutAlert<T>(view: T) where T: Transitioner, T: LogoutDelegate
}

final class LoginModel: LoginProtocol {
    var userConfig: UserConfigProtocol
    
    init(userConfig: UserConfigProtocol) {
        self.userConfig = userConfig
    }
    
    func autoLogin(autoLoginDelegate: AutoLoginDelegate) {
        // 前回の認証が一週間以内の場合のみオートログイン成功と判定します。
        if let latestDate = userConfig.latestLoginDate {
            if latestDate > Date().addingTimeInterval(-60 * 60 * 24 * 7) {
                autoLoginDelegate.didAutoLogin(isSuccess: true)
                return
            }
        }
        autoLoginDelegate.didAutoLogin(isSuccess: false)
    }

    func setUserConfig(userID: String, photoURL: URL?, displayName: String) {
        userConfig.userID = userID
        userConfig.photoURL = photoURL
        userConfig.displayName = displayName
        userConfig.latestLoginDate = Date()
    }
    func toLogoutAlert<T>(view: T) where T: Transitioner, T: LogoutDelegate {
        
        let alert = UIAlertController(title: "ログアウト", message: "ログアウトしますか？", preferredStyle: UIAlertController.Style.alert)
        
        // キャンセルボタン追加
        alert.addAction(
            UIAlertAction(
                title: "キャンセル",
                style: UIAlertAction.Style.cancel,
                handler: nil))
        
        // 確定ボタン追加
        alert.addAction(
            UIAlertAction(
                title: "ログアウト",
                style: UIAlertAction.Style.destructive) { _ in
                self.userConfig.removeUser()
                view.didLogout()
            }
        )
        
        view.present(alert, animated: true, completion: nil)
    }
}
