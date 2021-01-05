//
//  SplashRouter.swift
//  RssReader
//
//  Created by 若江照仁 on 2020/12/23.
//

import Foundation
import FirebaseUI

protocol SplashRouterProtocol {
    func toAuthView()
    func toArticleListView()
    func toSelectRssFeedView()
}

class SplashRouter: SplashRouterProtocol {
    private(set) weak var splashView: SplashViewProtocol!
    
    init(view: SplashViewProtocol) {
        splashView = view
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
        nav.modalPresentationStyle = .fullScreen
        splashView.present(nav,animated: true, completion: nil)
    }
    
    func toSelectRssFeedView() {
        let storyboard = UIStoryboard(name: "SelectRssFeed", bundle: nil)
        let selectRssFeedViewController = storyboard.instantiateViewController(identifier: "SelectRssFeedViewController") as! SelectRssFeedViewController
        selectRssFeedViewController.navigationItem.largeTitleDisplayMode = .automatic
        selectRssFeedViewController.navigationItem.title = "RSS Feedの選択"
        selectRssFeedViewController.inject(selectRssFeedRouter: SelectRssFeedRouter(view: selectRssFeedViewController), selectRssFeedModel: SelectRssFeedModel())
        let nav = UINavigationController(rootViewController: selectRssFeedViewController)
        nav.navigationBar.prefersLargeTitles = true
        nav.modalPresentationStyle = .fullScreen
        splashView.present(nav,animated: true, completion: nil)
    }
    
}

