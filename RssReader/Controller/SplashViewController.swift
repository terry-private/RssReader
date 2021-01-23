//
//  SplashViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2020/12/23.
//

import UIKit
import FirebaseUI

protocol SplashViewProtocol: Transitioner, FUIAuthDelegate {}

class SplashViewController: UIViewController, SplashViewProtocol {
    
    private var splashRouter: SplashRouterProtocol?
    private var loginModel: LoginProtocol?
    private var isAutoLogin = true
    var timer: Timer!
    var count: Float = 0
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginModel?.autoLoginDelegate = self
    }
    
    /// 初回表示時にオートログインを試します。
    /// 初回かどうかはshouldAutoLoginWhenFirst
    /// - Parameter animated: Bool
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        timer = Timer.scheduledTimer(timeInterval: 0.01,
                                     target: self,
                                     selector: #selector(timerUpdate),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func timerUpdate() {
        count += 0.01
        if count < 1.1 {
            progressView.setProgress(count, animated: true)
        } else {
            timer.invalidate()
            autoLogin()
        }
    }
    
    func autoLogin() {
        self.loginModel?.autoLogin()
        self.isAutoLogin = false
    }
    
    func inject(splashRouter: SplashRouterProtocol, autoLoginModel: LoginProtocol) {
        self.splashRouter = splashRouter
        self.loginModel = autoLoginModel
    }
    
}


extension SplashViewController: AutoLoginDelegate {
    func didAutoLogin(isSuccess: Bool) {
        if isSuccess {
            splashRouter?.toArticleListView()
        } else {
            splashRouter?.toAuthView()
        }
    }
}


extension SplashViewController: FUIAuthDelegate{
    //　認証画面から離れたときに呼ばれる（キャンセルボタン押下含む）
    public func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?){
        if let newUser = user {
            
            // 登録済みのユーザーの場合
            if newUser.uid == loginModel?.userConfig.userID {
                print("Log in!!")
                loginModel?.userConfig.latestLoginDate = Date()
                splashRouter?.toArticleListView()
                return
            }
            
            // 新規ユーザーの場合
            print("Sign up!!")
            loginModel?.setUserConfig(userID: newUser.uid, photoURL: newUser.photoURL, displayName: newUser.displayName ?? "")
            splashRouter?.toSelectRssFeedView()
            return
            
        }
        
        //失敗した場合
        print("can't auth")
        loginModel?.autoLogin()
    }
}
