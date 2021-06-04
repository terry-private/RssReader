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
    case couponMap
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
    case accountProperty
    
    // ArticleStatus
    case toRead
    case toNotRead
    case toFavorite
    case toNotFavorite
    case toLaterRead
    case toNotLaterRead
    
    // RssFeed
    case selectRssFeed
    case selectRssFeedType
    case articleTaggedWith
    case subscribeTo
    case singularFormOfRssFeed
    case pluralFormOfRssFeed
    case addNewRssFeed
    
    // Qiita
    case rssTypeOfQiita
    
    // Yahoo
    case yahooNews
    case selectYahooNewsTag
    
    // Coupon
    case QRCodeReader
    
    // Setting
    case refreshInterval
    case displayMode
    case subscriptionArticles
    case singularFormOfMinute
    case pluralFormOfMinute
    
    // Filter
    case filter
    case sort
    case orderByIssueDate
    case orderByTypeOfRssFeed
    case descending
    case ascending
    case displayOfRead
    case displayRead
    case daysOfDisplay
    case singularFormOfDay
    case pluralFormOfDay
    case displayArticle
    
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
    case tag
    case inputTag
    case halfAlphanumeric6_12
    case createANewAccount
    
    
}
