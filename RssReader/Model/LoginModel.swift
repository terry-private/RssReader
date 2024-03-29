//
//  LoginModel.swift
//  RssReader
//
//  Created by 若江照仁 on 2020/12/26.
//

import UIKit
import RealmSwift
import LineSDK

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
}
extension LoginProtocol {
    func toLogoutAlert<T>(view: T) where T: Transitioner, T: LogoutDelegate {
        switch userConfig.loginType{
        case "line":
            let alert = UIAlertController(title: "ログアウト", message: "ログアウトしますか？", preferredStyle: UIAlertController.Style.alert)
            alert.view.accessibilityIdentifier = "setting_lineLogout_alert"
            
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
                    LoginManager.shared.logout { result in
                        switch result {
                        case .success:
                            print("Logout Succeeded")
                        case .failure(let error):
                            print("Logout Failed: \(error)")
                        }
                    }
                    self.userConfig.removeUser()
                    view.didLogout()
                }
            )
            
            #if DebugSecure || DebugNonSecure
            alert.addAction(UIAlertAction(
                title: "トークンの更新",
                style: UIAlertAction.Style.default) { _ in
                
                    // トークンの更新
                    if let token = AccessTokenStore.shared.current {
                        print("Token expires at:\(token.expiresAt)")
                    }
                }
            )
            #endif
            view.present(alert, animated: true, completion: nil)
            
        case "mail":
            CommonRouter.toEditAccountPropertyView(view: view)
        default:
            userConfig.removeUser()
            view.didLogout()
        }
        
    }
}

final class LoginModel: LoginProtocol {
    var userConfig: UserConfigProtocol
    
    init(userConfig: UserConfigProtocol) {
        self.userConfig = userConfig
    }
    
    func autoLogin(autoLoginDelegate: AutoLoginDelegate) {
        switch userConfig.loginType {
        case "line":
            API.getProfile { result in
                switch result {
                case .success(let profile):
                    self.userConfig.loginType = "line"
                    self.userConfig.userID = profile.userID
                    self.userConfig.photoURL = profile.pictureURL
                    self.userConfig.displayName = profile.displayName
                    autoLoginDelegate.didAutoLogin(isSuccess: true)
                case .failure(let error):
                    print(error)
                    self.userConfig.removeUser()
                    autoLoginDelegate.didAutoLogin(isSuccess: false)
                }
            }
        case "mail":
            if let latestLoginDate = userConfig.latestLoginDate {
                if latestLoginDate > Date.current().addingTimeInterval(-60 * 60 * 24 * 7) {
                    userConfig.latestLoginDate = Date.current()
                    autoLoginDelegate.didAutoLogin(isSuccess: true)
                    return
                }
            }
            autoLoginDelegate.didAutoLogin(isSuccess: false)
        default:
            autoLoginDelegate.didAutoLogin(isSuccess: false)
        }
        
    }

    func setUserConfig(userID: String, photoURL: URL?, displayName: String) {
        userConfig.userID = userID
        userConfig.photoURL = photoURL
        userConfig.displayName = displayName
        userConfig.latestLoginDate = Date.current()
    }
}

