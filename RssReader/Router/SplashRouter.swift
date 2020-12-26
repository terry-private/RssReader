//
//  SplashRouter.swift
//  RssReader
//
//  Created by 若江照仁 on 2020/12/23.
//

import Foundation
import Firebase
import FirebaseUI

protocol SplashRouterProtocol: AnyObject {
    func transitionToAuthView()
}

class SplashRouter:NSObject, SplashRouterProtocol {
    private(set) weak var splashView: Transitioner!
    var authUI: FUIAuth { get { return FUIAuth.defaultAuthUI()!}}
    
    init(view: Transitioner) {
        splashView = view
    }
    
    func transitionToAuthView() {
        authUI.delegate = self
        authUI.providers = [
            FUIGoogleAuth(),
            FUIOAuth.twitterAuthProvider(),
            FUIEmailAuth()
        ]
        let authViewController = authUI.authViewController()
//        authViewController.modalPresentationStyle = .fullScreen
        splashView.present(authViewController, animated: true, completion: nil)
    }
    
    
}

extension SplashRouter: FUIAuthDelegate{
    //　認証画面から離れたときに呼ばれる（キャンセルボタン押下含む）
    public func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?){
        // 認証に成功した場合

        if error == nil {
            print("success!!")
        } else {
            //失敗した場合
            print("error")
        }
    }
}
