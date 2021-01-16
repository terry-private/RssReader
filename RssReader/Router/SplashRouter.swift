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
        CommonRouter.toAuth(view: splashView)
    }
    
    func toArticleListView() {
        CommonRouter.toArticleListView(view: splashView)
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

