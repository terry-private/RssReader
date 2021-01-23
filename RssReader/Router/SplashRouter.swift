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
    weak var parent: Transitioner?
    
    init(view: SplashViewProtocol, parent: Transitioner) {
        splashView = view
    }
    
    func toAuthView() {
        CommonRouter.toAuth(view: splashView)
    }
    
    func toArticleListView() {
        splashView.dismiss(animated: true)
    }
    
    func toSelectRssFeedView() {
        parent?.dismiss(animated: false)
        splashView.dismiss(animated: true)
    }
    
}

