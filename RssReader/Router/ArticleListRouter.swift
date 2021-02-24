//
//  ArticleListRouter.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/01/27.
//

import Foundation
import FirebaseUI

protocol ArticleListRouterProtocol {
    func toAuthView<T>(view: T) where T: Transitioner, T: FUIAuthDelegate
    func toSelectRssFeedView(view: Transitioner)
}

/// イニシャライズ時に元のVCをインジェクトします。
class ArticleListRouter: ArticleListRouterProtocol {
    func toAuthView<T>(view: T) where T: Transitioner, T: FUIAuthDelegate {
        CommonRouter.toAuth(view: view)
    }
    func toSelectRssFeedView(view: Transitioner) {
        CommonRouter.toSelectRssFeedView(view: view)
    }
}
