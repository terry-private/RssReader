//
//  ArticleListRouter.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/01/27.
//

import Foundation

protocol ArticleListRouterProtocol {
    var articleListViewController: ArticleListViewControllerProtocol? { get set }
    func toAuthView()
    func toSelectRssFeedView(rssFeedListModel: RssFeedListModelProtocol)
}
extension ArticleListRouterProtocol {
    mutating func inject(articleListViewController: ArticleListViewControllerProtocol) {
        self.articleListViewController = articleListViewController
    }
}

/// イニシャライズ時に元のVCをインジェクトします。
class ArticleListRouter: ArticleListRouterProtocol {
    weak var articleListViewController: ArticleListViewControllerProtocol?
    
    
    func toAuthView() {
        CommonRouter.toAuth(view: articleListViewController!)
    }
    func toSelectRssFeedView(rssFeedListModel: RssFeedListModelProtocol) {
        CommonRouter.toSelectRssFeedView(view: articleListViewController!, rssFeedListModel: rssFeedListModel)
    }
}
