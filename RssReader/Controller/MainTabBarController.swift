//
//  MainTabBarController.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/01/20.
//

import UIKit

class MainTabBarController: UITabBarController, Transitioner {
    var isFirst = true
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTab()
        
    }
    
    
    func setupTab() {
        //MARK:- articleViewController
        let articleListViewController = UIStoryboard(name: "ArticleList", bundle: nil).instantiateViewController(identifier: "ArticleListViewController") as! ArticleListViewController
        
        //inject
        articleListViewController.inject(
            loginModel: DummyLoginModel(), rssFeedListModel: DummyRssFeedListModel(),
            articleListRouter: DummyArticleListRouter(articleListViewController: articleListViewController)
        )
        articleListViewController.tabBarItem = UITabBarItem(title: "記事一覧", image: UIImage(systemName: "list.bullet.rectangle"), tag: 0)
        let articleListNav = UINavigationController(rootViewController: articleListViewController)
        articleListNav.navigationBar.prefersLargeTitles = true
        
        // MARK:- settingViewController
        let settingViewController = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(identifier: "SettingViewController") as! SettingViewController
        settingViewController.tabBarItem = UITabBarItem(title: "設定", image: UIImage(systemName: "gear"), tag: 0)
        
        viewControllers = [articleListNav, settingViewController]
        
    }
}
