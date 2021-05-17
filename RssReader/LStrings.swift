//
//  LStrings.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/05/14.
//

import Foundation

enum LStrings: String {
    var value: String {
        NSLocalizedString(self.rawValue, comment: "")
    }
    
    // MainTabBar
    case latestArticles
    case laterRead
    case favorite
    case setting
    
    // LoginView
    case idLoginButtonTitle
    case loginAlertMessage
    case errorAlertTitle
    case halfAlphanumeric8_12
    case countErrorMessage
    case alphanumericErrorMessage
    
    // MailLoginView
    case mailLogin
    
    // AccountPropertyView
    case profileImage
    
    // ArticleStatus
    case toRead
    case toNotRead
    case toFavorite
    case toNotFavorite
    case toLaterRead
    case toNotLaterRead
    
    // RssFeed
    case selectRssFeed
    case articleTaggedWith
    case subscribeTo
    case singularFormOfRssFeed
    case pluralFormOfRssFeed
    case addNewRssFeed
    
    // CommonWord
    case login
    case logout
    case done
    case enter
    case cancel
    case close
    case back
    case edit
    
    // AppWord
    case emailAddress
    case password
    case username
    case halfAlphanumeric6_12
    case createANewAccount
}
