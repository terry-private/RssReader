//
//  SplashRouter.swift
//  RssReader
//
//  Created by 若江照仁 on 2020/12/23.
//

import Foundation
import FirebaseUI

protocol SplashRouterProtocol: AnyObject {
    func transition(isAuthenticated: Bool)
}

class SplashRouter: SplashRouterProtocol {
    private(set) weak var splashView: SplashViewProtocol!
    
    init(view: SplashViewProtocol) {
        splashView = view
    }
    
    func transition(isAuthenticated: Bool) {
        if isAuthenticated {
            toArticleListView()
        } else {
            toAuthView()
        }
    }
    
    func toAuthView() {
        let authUI = FUIAuth.defaultAuthUI()!
        authUI.delegate = splashView
        authUI.providers = [
            FUIGoogleAuth(),
            FUIOAuth.twitterAuthProvider(),
            FUIEmailAuth()
        ]
        let authViewController = authUI.authViewController()
        authViewController.modalPresentationStyle = .fullScreen
        splashView.present(authViewController, animated: true, completion: nil)
    }
    
    func toArticleListView() {
        let storyboard = UIStoryboard(name: "ArticleList", bundle: nil)
        let articleListViewController = storyboard.instantiateViewController(identifier: "ArticleListViewController") as! ArticleListViewController
        articleListViewController.navigationItem.largeTitleDisplayMode = .automatic
        articleListViewController.navigationItem.title = "記事一覧"
        
        let nav = UINavigationController(rootViewController: articleListViewController)
        nav.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label, .font:UIFont.systemFont(ofSize: 18, weight: .thin)]
        nav.modalPresentationStyle = .fullScreen
        splashView.present(nav,animated: true, completion: nil)
    }
    
    
}

