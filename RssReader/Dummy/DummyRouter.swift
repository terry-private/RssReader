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
    
    init(view: SplashViewProtocol) {
        splashView = view
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
        let storyboard = UIStoryboard(name: "SelectRssFeed", bundle: nil)
        let selectRssFeedViewController = storyboard.instantiateViewController(identifier: "SelectRssFeedViewController") as! SelectRssFeedViewController
        selectRssFeedViewController.navigationItem.largeTitleDisplayMode = .automatic
        selectRssFeedViewController.navigationItem.title = "記事の選択"
        selectRssFeedViewController.inject(selectRssFeedRouter: SelectRssFeedRouter(view: selectRssFeedViewController))
        let nav = UINavigationController(rootViewController: selectRssFeedViewController)
        nav.modalPresentationStyle = .fullScreen
        splashView.present(nav,animated: true, completion: nil)
    }
    
    
}
