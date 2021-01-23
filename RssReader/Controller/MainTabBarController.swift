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
        articleListViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 0)
        articleListViewController.navigationItem.title = "記事一覧"
        let articleListNav = UINavigationController(rootViewController: articleListViewController)
        articleListNav.navigationBar.prefersLargeTitles = true
        
        viewControllers = [articleListNav, UIViewController()]
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
}
