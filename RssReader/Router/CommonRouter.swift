//
//  CommonRouter.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/01/07.
//

import Foundation
import FirebaseUI
import SideMenu

class CommonRouter {
    /// 認証画面へ
    /// - Parameter view: FUIAuthDelegateが必要
    /// SplashView = Transitioner + FUIAuthDelegate
    class func toAuth<T>(view: T) where T: Transitioner, T: FUIAuthDelegate  {
        let authUI = FUIAuth.defaultAuthUI()!
        authUI.delegate = view
        authUI.providers = [
            FUIGoogleAuth(authUI: authUI),
            FUIOAuth.twitterAuthProvider(),
            FUIEmailAuth()
        ]
        let authViewController = authUI.authViewController()
        authViewController.modalPresentationStyle = .fullScreen
        view.present(authViewController, animated: true, completion: nil)
    }
    
    class func toSelectRssFeedView(view: Transitioner) {
        let storyboard = UIStoryboard(name: "SelectRssFeed", bundle: nil)
        let selectRssFeedViewController = storyboard.instantiateViewController(identifier: "SelectRssFeedViewController") as! SelectRssFeedViewController
        selectRssFeedViewController.navigationItem.title = "RSS Feedの選択"
        let nav = UINavigationController(selectRssFeedViewController)
        nav.modalPresentationStyle = .fullScreen
        view.present(nav,animated: true, completion: nil)
    }
    
    class func toSelectRssFeedTypeView<T>(view: T) where T: Transitioner, T: SelectRssFeedDelegate {
        let storyboard = UIStoryboard(name: "SelectRssFeedType", bundle: nil)
        let selectRssFeedTypeViewController = storyboard.instantiateViewController(identifier: "SelectRssFeedTypeViewController") as! SelectRssFeedTypeViewController
        selectRssFeedTypeViewController.navigationItem.title = "購読記事の選択"
        selectRssFeedTypeViewController.delegate = view
        let nav = UINavigationController(selectRssFeedTypeViewController)
        view.present(nav, animated: true, completion: nil)
    }
    
    class func toSelectYahooTagView<T>(view: T) where T: Transitioner, T: SelectRssFeedDelegate {
        let storyboard = UIStoryboard(name: "SelectYahooTag", bundle: nil)
        let selectYahooTagViewController = storyboard.instantiateViewController(identifier: "SelectYahooTagViewController") as! SelectYahooTagViewController
        selectYahooTagViewController.navigationItem.title = "Yahoo!Newsタグの選択"
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
        view.present(nav, animated: true, completion: nil)
    }
    
    class func toFilterMenuView<T>(view: T) where T: Transitioner, T: ArticleKeySortable {
        let storyboard = UIStoryboard(name: "FilterMenu", bundle: nil)
        let filterMenuViewController = storyboard.instantiateViewController(withIdentifier: "FilterMenuViewController") as! FilterMenuViewController
        filterMenuViewController.articleKeySortable = view
        filterMenuViewController.navigationItem.title = "フィルター"
        let nav = SideMenuNavigationController(rootViewController: filterMenuViewController)
        nav.menuWidth = view.view.bounds.width - 40
        nav.presentationStyle = .menuSlideIn
        nav.presentationStyle.presentingEndAlpha = 0.5
        nav.leftSide = true
        view.present(nav, animated: true, completion: nil)
    }
}
