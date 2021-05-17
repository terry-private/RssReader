//
//  CommonRouter.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/01/07.
//

import Foundation
import SideMenu

class CommonRouter {
    /// 認証画面へ
    /// - Parameter view: FUIAuthDelegateが必要
    /// SplashView = Transitioner + FUIAuthDelegate
    class func toAuth<T>(view: T) where T: Transitioner {
        let loginViewController = LoginViewController()
        loginViewController.navigationItem.title = LStrings.login.value
        let nav = UINavigationController(loginViewController)
        nav.modalPresentationStyle = .fullScreen
        view.present(nav, animated: true, completion: nil)
    }
    
    class func toNewAccountPropertyView(view: Transitioner, defaultData: [String: String]) {
        let storyboard = UIStoryboard(name: "AccountProperty", bundle: nil)
        let accountPropertyVC = storyboard.instantiateViewController(identifier: "AccountPropertyViewController") as! AccountPropertyViewController
        accountPropertyVC.navigationItem.title = LStrings.createANewAccount.value
        accountPropertyVC.defaultData = defaultData
        view.pushViewController(accountPropertyVC, animated: true)
    }
    
    class func toEditAccountPropertyView(view: Transitioner) {
        let storyboard = UIStoryboard(name: "AccountProperty", bundle: nil)
        let accountPropertyVC = storyboard.instantiateViewController(identifier: "AccountPropertyViewController") as! AccountPropertyViewController
        accountPropertyVC.useCase = .EditAccount
        accountPropertyVC.navigationItem.title = LStrings.accountProperty.value
        let nav = UINavigationController(accountPropertyVC)
        nav.modalPresentationStyle = .fullScreen
        view.present(nav,animated: true, completion: nil)
    }
    
    class func toMailLoginView<T>(view: T) where T: Transitioner {
        let storyboard = UIStoryboard(name: "MailLogin", bundle: nil)
        let mailLoginVC = storyboard.instantiateViewController(identifier: "MailLoginViewController") as! MailLoginViewController
        mailLoginVC.navigationItem.title = LStrings.mailLogin.value
        view.pushViewController(mailLoginVC, animated: true)
    }
    
    class func toSelectRssFeedView(view: Transitioner) {
        let storyboard = UIStoryboard(name: "SelectRssFeed", bundle: nil)
        let selectRssFeedViewController = storyboard.instantiateViewController(identifier: "SelectRssFeedViewController") as! SelectRssFeedViewController
        selectRssFeedViewController.navigationItem.title = LStrings.selectRssFeed.value
        let nav = UINavigationController(selectRssFeedViewController)
        nav.modalPresentationStyle = .fullScreen
        view.present(nav,animated: true, completion: nil)
    }
    
    class func toSelectRssFeedTypeView<T>(view: T) where T: Transitioner, T: SelectRssFeedDelegate {
        let storyboard = UIStoryboard(name: "SelectRssFeedType", bundle: nil)
        let selectRssFeedTypeViewController = storyboard.instantiateViewController(identifier: "SelectRssFeedTypeViewController") as! SelectRssFeedTypeViewController
        selectRssFeedTypeViewController.navigationItem.title = LStrings.selectRssFeedType.value
        selectRssFeedTypeViewController.delegate = view
        let nav = UINavigationController(selectRssFeedTypeViewController)
        view.present(nav, animated: true, completion: nil)
    }
    
    class func toSelectYahooTagView<T>(view: T) where T: Transitioner, T: SelectRssFeedDelegate {
        let storyboard = UIStoryboard(name: "SelectYahooTag", bundle: nil)
        let selectYahooTagViewController = storyboard.instantiateViewController(identifier: "SelectYahooTagViewController") as! SelectYahooTagViewController
        selectYahooTagViewController.navigationItem.title = LStrings.selectYahooNewsTag.value
        selectYahooTagViewController.delegate = view
        view.pushViewController(selectYahooTagViewController, animated: true)
    }
    
    class func toArticleDetailView(view: Transitioner, article: Article) {
        let storyboard = UIStoryboard(name: "ArticleDetail", bundle: nil)
        let articleDetailViewController = storyboard.instantiateViewController(identifier: "ArticleDetailViewController") as! ArticleDetailViewController
        articleDetailViewController.navigationItem.title = article.item.title
        articleDetailViewController.article = article
        let nav = UINavigationController(rootViewController: articleDetailViewController)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.barTintColor = .init(named: "MainBG")
        view.present(nav, animated: true, completion: nil)
    }
    
    class func toFilterMenuView<T>(view: T) where T: Transitioner, T: KeysSortable {
        let storyboard = UIStoryboard(name: "FilterMenu", bundle: nil)
        let filterMenuViewController = storyboard.instantiateViewController(withIdentifier: "FilterMenuViewController") as! FilterMenuViewController
        filterMenuViewController.articleKeySortable = view
        filterMenuViewController.navigationItem.title = LStrings.filter.value
        let nav = SideMenuNavigationController(rootViewController: filterMenuViewController)
        nav.menuWidth = view.view.bounds.width - 40
        nav.presentationStyle = .menuSlideIn
        nav.presentationStyle.presentingEndAlpha = 0.5
        nav.leftSide = true
        view.present(nav, animated: true, completion: nil)
    }
}
