//
//  MainTabBarController.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/01/20.
//

import UIKit

class MainTabBarController: UITabBarController, Transitioner {
    // 本番環境
//    var loginModel: LoginProtocol = LoginModel(userConfig: UserConfig())
//    var rssFeedListModel: RssFeedListModelProtocol = DummyRssFeedListModel()
//    var articleListRouter: ArticleListRouterProtocol = ArticleListRouter()
    
    // テスト環境
    private var loginModel: LoginProtocol = DummyLoginModel()
    private var rssFeedListModel: RssFeedListModelProtocol = DummyRssFeedListModel()
    private var articleListRouter: ArticleListRouterProtocol = DummyArticleListRouter()
    
    // MARK:- TabにセットするUINavigationControllers
    private var articleListNav: UINavigationController {
        get {
            let articleListViewController = UIStoryboard(name: "ArticleList", bundle: nil).instantiateViewController(identifier: "ArticleListViewController") as! ArticleListViewController
            
            // inject
            articleListViewController.inject(
                loginModel: loginModel,
                rssFeedListModel: rssFeedListModel,
                articleListRouter: articleListRouter
            )
            articleListViewController.tabBarItem = UITabBarItem(title: "記事一覧", image: UIImage(systemName: "list.bullet.rectangle"), tag: 0)
            return UINavigationController(articleListViewController)
        }
    }
    
    private var settingNav: UINavigationController {
        get {
            let settingViewController = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(identifier: "SettingViewController") as! SettingViewController
            settingViewController.tabBarItem = UITabBarItem(title: "設定", image: UIImage(systemName: "gear"), tag: 0)
            
            // inject
            let settingModel = SettingModel(loginModel: loginModel, rssFeedListModel: rssFeedListModel)
            settingViewController.inject(settingModel: settingModel)
            
            return UINavigationController(settingViewController)
        }
    }
    
    // MARK:- ライフサイクル系
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTab()
        
    }

    func setupTab() {
        viewControllers = [articleListNav, settingNav]
    }
}
