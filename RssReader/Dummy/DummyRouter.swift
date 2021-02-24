//
//  DummyRouter.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/01/05.
//

import Foundation
import FirebaseUI


class DummyArticleListRouter: ArticleListRouterProtocol {
    func toAuthView<T>(view: T) where T: Transitioner, T: FUIAuthDelegate {
        CommonRouter.toSelectRssFeedView(view: view)
    }
    func toSelectRssFeedView(view: Transitioner) {
        CommonRouter.toSelectRssFeedView(view: view)
    }
}
