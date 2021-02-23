//
//  DummyRouter.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/01/05.
//

import Foundation
import UIKit


class DummyArticleListRouter: ArticleListRouterProtocol {
    weak var articleListViewController: ArticleListViewControllerProtocol?
    func toAuthView() {
        toSelectRssFeedView(rssFeedListModel: DummyRssFeedListModel())
    }
    func toSelectRssFeedView(rssFeedListModel: RssFeedListModelProtocol) {
        CommonRouter.toSelectRssFeedView(view: articleListViewController!, rssFeedListModel: rssFeedListModel)
    }
}
