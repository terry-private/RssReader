//
//  SelectRssFeedRouter.swift
//  RssReader
//
//  Created by 若江照仁 on 2020/12/27.
//

import UIKit

protocol SelectRssFeedRouterProtocol {
    func toArticleListView()
}

class SelectRssFeedRouter: SelectRssFeedRouterProtocol {
    private(set) weak var selectRssFeedView: SelectRssFeedViewProtocol!
    
    init(view: SelectRssFeedViewProtocol) {
        selectRssFeedView = view
    }
    
    func toArticleListView() {
        let storyboard = UIStoryboard(name: "ArticleList", bundle: nil)
        let articleListViewController = storyboard.instantiateViewController(identifier: "ArticleListViewController") as! ArticleListViewController
        articleListViewController.navigationItem.largeTitleDisplayMode = .automatic
        articleListViewController.navigationItem.title = "記事一覧"
        
        let nav = UINavigationController(rootViewController: articleListViewController)
        nav.navigationBar.prefersLargeTitles = true
        nav.modalPresentationStyle = .fullScreen
        selectRssFeedView.present(nav,animated: true, completion: nil)
    }
}
