//
//  YahooTag.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/13.
//

import Foundation

enum YahooTag: CaseIterable {
    case main
    case world
    case entertainment
    case informationTechnology
    case local
    case domestic
    case business
    case sports
    case science
    
    var name: String {
        switch self {
        case .main: return "主要"
        case .world: return "国際"
        case .entertainment: return "エンタメ"
        case .informationTechnology: return "IT"
        case .local: return "地域"
        case .domestic: return "国内"
        case .business: return "経済"
        case .sports: return "スポーツ"
        case .science: return "科学"
        }
    }
    var url: String {
        switch self {
        case .main:
            return "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fnews.yahoo.co.jp%2Frss%2Ftopics%2Ftop-picks.xml"
        case .world:
            return "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fnews.yahoo.co.jp%2Frss%2Ftopics%2Fworld.xml"
        case .entertainment:
            return "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fnews.yahoo.co.jp%2Frss%2Ftopics%2Fentertainment.xml"
        case .informationTechnology:
            return "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fnews.yahoo.co.jp%2Frss%2Ftopics%2Fit.xml"
        case .local:
            return "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fnews.yahoo.co.jp%2Frss%2Ftopics%2Flocal.xml"
        case .domestic:
            return "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fnews.yahoo.co.jp%2Frss%2Ftopics%2Fdomestic.xml"
        case .business:
            return "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fnews.yahoo.co.jp%2Frss%2Ftopics%2Fbusiness.xml"
        case .sports:
            return "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fnews.yahoo.co.jp%2Frss%2Ftopics%2Fsports.xml"
        case .science:
            return "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fnews.yahoo.co.jp%2Frss%2Ftopics%2Fscience.xml"
        }
    }
}
