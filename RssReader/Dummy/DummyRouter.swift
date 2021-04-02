//
//  DummyRouter.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/01/05.
//

import Foundation


class DummyArticleListRouter: ArticleListRouterProtocol {
    func toAuthView<T>(view: T) where T: Transitioner{
        CommonRouter.toSelectRssFeedView(view: view)
    }
    func toSelectRssFeedView(view: Transitioner) {
        CommonRouter.toSelectRssFeedView(view: view)
    }
}
