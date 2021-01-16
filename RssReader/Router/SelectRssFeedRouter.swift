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
        CommonRouter.toArticleListView(view: selectRssFeedView)
    }
}
