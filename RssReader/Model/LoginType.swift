//
//  LoginType.swift
//  RssReader
//
//  Created by 若江照仁 on 2020/12/23.
//

import Foundation

enum LoginType {
    case Line
    case Facebook
    case Twitter
    
    var snsModel: SNSAuthenticateProtocol {
        switch self {
        case .Line:
            return LineModel.sharedInstance
        case .Facebook:
            return FacebookModel.sharedInstance
        case .Twitter:
            return TwitterModel.sharedInstance
        }
    }

    var snsID: String {
        return self.snsModel.snsID
    }

    var snsToken: String {
        return self.snsModel.snsToken
    }
}
