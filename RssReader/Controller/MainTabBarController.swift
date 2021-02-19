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
        let articleListViewController = UIStoryboard(name: "ArticleList", bundle: nil).instantiateViewController(identifier: "ArticleListViewController") as! ArticleListViewController
        
        //inject
        articleListViewController.inject(
            loginModel: DummyLoginModel(), rssFeedListModel: DummyRssFeedListModel() as RssFeedListModelProtocol,
            articleListRouter: DummyArticleListRouter(articleListViewController: articleListViewController)
        )
        articleListViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 0)
        let articleListNav = UINavigationController(rootViewController: articleListViewController)
        articleListNav.navigationBar.prefersLargeTitles = true
        
        viewControllers = [articleListNav, UIViewController()]
        
    }
}
