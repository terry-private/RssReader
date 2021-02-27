//
//  MainTabBarController.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/01/20.
//

import UIKit

class MainTabBarController: UITabBarController, Transitioner {
    // 本番環境
    private var articleListRouter: ArticleListRouterProtocol = ArticleListRouter()
    
    // テスト環境
//    private var articleListRouter: ArticleListRouterProtocol = DummyArticleListRouter()
    
    // MARK:- TabにセットするUINavigationControllers
    private var articleListNav: UINavigationController {
        get {
            let articleListViewController = UIStoryboard(name: "ArticleList", bundle: nil).instantiateViewController(identifier: "ArticleListViewController") as! ArticleListViewController
            
            // inject
            articleListViewController.inject(
                articleListRouter: articleListRouter
            )
            articleListViewController.tabBarItem = UITabBarItem(title: "最新記事", image: UIImage(systemName: "list.bullet.rectangle"), tag: 0)
            return UINavigationController(articleListViewController)
        }
    }
    
    private var laterReadNav: UINavigationController {
        let laterReadListViewController = UIStoryboard(name: "LaterReadList", bundle: nil).instantiateViewController(identifier: "LaterReadListViewController") as! LaterReadListViewController
        
        laterReadListViewController.tabBarItem = UITabBarItem(title: "後で読む", image: UIImage(systemName: "tray"), tag: 0)
        return UINavigationController(laterReadListViewController)
    }
    
    private var starListNav: UINavigationController {
        let starListViewController = UIStoryboard(name: "StarList", bundle: nil).instantiateViewController(identifier: "StarListViewController") as! StarListViewController
        
        starListViewController.tabBarItem = UITabBarItem(title: "お気に入り", image: UIImage(systemName: "star"), tag: 0)
        return UINavigationController(starListViewController)
    }
    
    private var settingNav: UINavigationController {
        get {
            let settingViewController = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(identifier: "SettingViewController") as! SettingViewController
            settingViewController.tabBarItem = UITabBarItem(title: "設定", image: UIImage(systemName: "gear"), tag: 0)
            
            return UINavigationController(settingViewController)
        }
    }
    
    
    // MARK:- ライフサイクル系
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTab()
        
    }

    func setupTab() {
        viewControllers = [articleListNav, laterReadNav, starListNav, settingNav]
    }
}
