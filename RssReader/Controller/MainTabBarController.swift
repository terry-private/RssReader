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
            let bar = UITabBarItem(title: LStrings.latestArticles.value, image: UIImage(systemName: "list.bullet.rectangle"), tag: 0)
            bar.accessibilityIdentifier = "articleList_bar"
            articleListViewController.tabBarItem = bar
            return UINavigationController(articleListViewController)
        }
    }
    
    private var laterReadNav: UINavigationController {
        let laterReadListViewController = UIStoryboard(name: "LaterReadList", bundle: nil).instantiateViewController(identifier: "LaterReadListViewController") as! LaterReadListViewController
        let bar = UITabBarItem(title: LStrings.laterRead.value, image: UIImage(systemName: "tray"), tag: 0)
        bar.accessibilityIdentifier = "laterRead_bar"
        laterReadListViewController.tabBarItem = bar
        return UINavigationController(laterReadListViewController)
    }
    
    private var starListNav: UINavigationController {
        let starListViewController = UIStoryboard(name: "StarList", bundle: nil).instantiateViewController(identifier: "StarListViewController") as! StarListViewController
        let bar = UITabBarItem(title: LStrings.favorite.value, image: UIImage(systemName: "star"), tag: 0)
        bar.accessibilityIdentifier = "starList_bar"
        starListViewController.tabBarItem = bar
        return UINavigationController(starListViewController)
    }
    
    private var couponMapNav: UINavigationController {
        let couponMapViewController = UIStoryboard(name: "CouponMap", bundle: nil).instantiateViewController(identifier: "CouponMapViewController") as! CouponMapViewController
        let bar = UITabBarItem(title: LStrings.couponMap.value, image: UIImage(systemName: "mappin.and.ellipse"), tag: 0)
        bar.accessibilityIdentifier = "couponMap_bar"
        couponMapViewController.tabBarItem = bar
        return UINavigationController(couponMapViewController, prefersLargeTitles: false)
    }
    
    private var settingNav: UINavigationController {
        get {
            let settingViewController = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(identifier: "SettingViewController") as! SettingViewController
            let bar = UITabBarItem(title: LStrings.setting.value, image: UIImage(systemName: "gear"), tag: 0)
            bar.accessibilityIdentifier = "setting_bar"
            settingViewController.tabBarItem = bar
            
            return UINavigationController(settingViewController)
        }
    }
    
    
    // MARK:- ライフサイクル系
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTab()
    }

    func setupTab() {
        viewControllers = [articleListNav, laterReadNav, starListNav, couponMapNav, settingNav]
    }
}
