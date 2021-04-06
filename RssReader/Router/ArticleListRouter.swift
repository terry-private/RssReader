//
//  ArticleListRouter.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/01/27.
//

import Foundation

protocol ArticleListRouterProtocol {
    func toAuthView<T>(view: T) where T: Transitioner
    func toSelectRssFeedView(view: Transitioner)
}

/// イニシャライズ時に元のVCをインジェクトします。
class ArticleListRouter: ArticleListRouterProtocol {
    func toAuthView<T>(view: T) where T: Transitioner {
        CommonRouter.toAuth(view: view)
    }
    func toSelectRssFeedView(view: Transitioner) {
        CommonRouter.toSelectRssFeedView(view: view)
    }
}
