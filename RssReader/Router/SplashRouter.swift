//
//  SplashRouter.swift
//  RssReader
//
//  Created by 若江照仁 on 2020/12/23.
//

import Foundation
import FirebaseUI

protocol SplashRouterProtocol {
    func toAuthView()
    func toArticleListView()
    func toSelectRssFeedView()
}

class SplashRouter: SplashRouterProtocol {
    private(set) weak var splashView: SplashViewProtocol!
    
    init(view: SplashViewProtocol) {
        splashView = view
    }
    
    
    func toAuthView() {
        CommonRouter.toAuth(view: splashView)
    }
    
    func toArticleListView() {
        CommonRouter.toArticleListView(view: splashView)
    }
    
    func toSelectRssFeedView() {
        CommonRouter.toSelectRssFeedView(view: splashView)
    }
    
}

