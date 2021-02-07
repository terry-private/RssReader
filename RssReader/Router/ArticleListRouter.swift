//
//  ArticleListRouter.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/01/27.
//

import Foundation

protocol ArticleListRouterProtocol {
    func toAuthView()
    func toSelectRssFeedView()
}

/// イニシャライズ時に元のVCをインジェトします。
class ArticleListRouter: ArticleListRouterProtocol {
    weak var articleListViewController: ArticleListViewControllerProtocol!
    
    init(articleListViewController: ArticleListViewControllerProtocol) {
        self.articleListViewController = articleListViewController
    }
    
    func toAuthView() {
        CommonRouter.toAuth(view: articleListViewController)
    }
    func toSelectRssFeedView() {
        CommonRouter.toSelectRssFeedView(view: articleListViewController)
    }
}
