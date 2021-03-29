//
//  LoginModel.swift
//  RssReader
//
//  Created by 若江照仁 on 2020/12/26.
//

import Foundation
import Firebase
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
    }
}

final class LoginModel: LoginProtocol {
    var userConfig: UserConfigProtocol
    
    init(userConfig: UserConfigProtocol) {
        self.userConfig = userConfig
    }
    
    func autoLogin(autoLoginDelegate: AutoLoginDelegate) {
        
        API.getProfile { result in
            switch result {
            case .success(let profile):
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
    }

    func setUserConfig(userID: String, photoURL: URL?, displayName: String) {
        userConfig.userID = userID
        userConfig.photoURL = photoURL
        userConfig.displayName = displayName
        userConfig.latestLoginDate = Date()
    }
}


protocol AuthTypeProtocol {
    func autoLogin<T>(authView: T) where T: Transitioner, T: AutoLoginDelegate
    func login<T>(authView: T) where T: Transitioner, T: LoginDelegate
    func logout<T>(authView: T) where T: Transitioner, T: LogoutDelegate
    func signOut<T>(authView: T) where T: Transitioner, T: LogoutDelegate
    var isLogin: Bool { get }
}

protocol LoginDelegate: AnyObject {
    func didLogin(isSuccess: Bool)
}


protocol AuthProtocol: AuthTypeProtocol {
    var authType: AuthTypeProtocol? { get set }
    var userConfig: UserConfigProtocol? { get set }

    var isLogin: Bool { get }
    func autoLogin<T>(authView: T) where T: Transitioner, T: AutoLoginDelegate
    func login<T>(authView: T) where T: Transitioner, T: LoginDelegate
    func logout<T>(authView: T) where T: Transitioner, T: LogoutDelegate
    func signOut<T>(authView: T) where T: Transitioner, T: LogoutDelegate
}

class AuthModel: AuthProtocol {
    var authType: AuthTypeProtocol? {
        get {
            if let type = UserDefaults.standard.string(forKey: "loginType") {
                switch type {
                case "mail":
                    return MailAuthType()
                case "line":
                    return LineAuthType()
                default:
                    return nil
                }
            }
            return nil
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "loginType")
        }
    }
    
    var isLogin: Bool {
        get {
            return authType?.isLogin ?? false
        }
    }
    
    var userConfig: UserConfigProtocol?
    
    func autoLogin<T>(authView: T) where T : AutoLoginDelegate, T : Transitioner {
        authType?.autoLogin(authView: authView)
    }
    
    func login<T>(authView: T) where T : LoginDelegate, T : Transitioner {
        authType?.login(authView: authView)
    }
    
    func logout<T>(authView: T) where T : LogoutDelegate, T : Transitioner {
        authType?.logout(authView: authView)
    }
    
    func signOut<T>(authView: T) where T : LogoutDelegate, T : Transitioner {
        authType?.signOut(authView: authView)
    }
    
}


class MailAuthType: AuthTypeProtocol {
    
    // https://develop.hateblo.jp/entry/iosapp-uiimage-save
    
    var isLogin: Bool = true
    
    func autoLogin<T>(authView: T) where T : AutoLoginDelegate, T : Transitioner {
        authView.didAutoLogin(isSuccess: true)
    }
    
    func login<T>(authView: T) where T : LoginDelegate, T : Transitioner {
        authView.didLogin(isSuccess: true)
    }
    
    func logout<T>(authView: T) where T : LogoutDelegate, T : Transitioner {
        authView.didLogout()
    }
    
    func signOut<T>(authView: T) where T : LogoutDelegate, T : Transitioner {
        authView.didLogout()
    }
    
}

class LineAuthType: AuthTypeProtocol {
    func logout<T>(authView: T) where T : LogoutDelegate, T : Transitioner {
        authView.didLogout()
    }
    
    func signOut<T>(authView: T) where T : LogoutDelegate, T : Transitioner {
        authView.didLogout()
    }
    
    func autoLogin<T>(authView: T) where T : AutoLoginDelegate, T : Transitioner {
        API.getProfile { result in
            switch result {
            case .success(let profile):
                CommonData.loginModel.userConfig.userID = profile.userID
                CommonData.loginModel.userConfig.photoURL = profile.pictureURL
                CommonData.loginModel.userConfig.displayName = profile.displayName
                authView.didAutoLogin(isSuccess: true)
            case .failure(let error):
                print(error)
                CommonData.loginModel.userConfig.removeUser()
                authView.didAutoLogin(isSuccess: false)
            }
        }
    }
    
    func login<T>(authView: T) where T : LoginDelegate, T : Transitioner {
        authView.didLogin(isSuccess: true)
    }
    
    var isLogin: Bool = false
}
