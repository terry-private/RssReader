//
//  CommonRouter.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/01/07.
//

import Foundation
import FirebaseUI

class CommonRouter {
    /// 認証画面へ
    /// - Parameter view: FUIAuthDelegateが必要
    /// SplashView = Transitioner + FUIAuthDelegate
    class func toAuth(view: ArticleListViewControllerProtocol) {
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
    
    class func toSelectRssFeedView(view: Transitioner, rssFeedListModel: RssFeedListModelProtocol) {
        let storyboard = UIStoryboard(name: "SelectRssFeed", bundle: nil)
        let selectRssFeedViewController = storyboard.instantiateViewController(identifier: "SelectRssFeedViewController") as! SelectRssFeedViewController
        selectRssFeedViewController.navigationItem.title = "RSS Feedの選択"
        selectRssFeedViewController.inject(rssFeedListModel: rssFeedListModel)
        let nav = UINavigationController(selectRssFeedViewController)
        nav.modalPresentationStyle = .fullScreen
        view.present(nav,animated: true, completion: nil)
    }
    
    class func toSelectRssFeedTypeView<T>(view: T, typeList: [RssFeedTypeProtocol]) where T: Transitioner, T: SelectRssFeedDelegate {
        let storyboard = UIStoryboard(name: "SelectRssFeedType", bundle: nil)
        let selectRssFeedTypeViewController = storyboard.instantiateViewController(identifier: "SelectRssFeedTypeViewController") as! SelectRssFeedTypeViewController
        selectRssFeedTypeViewController.navigationItem.title = "購読記事の選択"
        selectRssFeedTypeViewController.typeList = typeList
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
}
