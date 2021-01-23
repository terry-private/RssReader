//
//  DummyRouter.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/01/05.
//

import Foundation
import UIKit


class DummySplashRouter: SplashRouterProtocol {
    private(set) weak var splashView: SplashViewProtocol!
    weak var parent: Transitioner?
    
    init(view: SplashViewProtocol, parent: Transitioner) {
        splashView = view
        self.parent = parent
    }
    func toAuthView() {
        toSelectRssFeedView()
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
        splashView.dismiss(animated: true)
    }
    
    
}
