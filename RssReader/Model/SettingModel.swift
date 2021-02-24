//
//  SettingModel.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/19.
//

import Foundation

protocol SettingModelProtocol {
    var loginModel: LoginProtocol { get set }
    var rssFeedListModel: RssFeedListModelProtocol { get set }
}

final class SettingModel: SettingModelProtocol {    
    var loginModel: LoginProtocol
    var rssFeedListModel: RssFeedListModelProtocol
    
    init(loginModel: LoginProtocol, rssFeedListModel: RssFeedListModelProtocol) {
        self.loginModel = loginModel
        self.rssFeedListModel = rssFeedListModel
    }
}
