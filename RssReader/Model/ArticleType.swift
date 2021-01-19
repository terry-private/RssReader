//
//  ArticleType.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/01/20.
//

import UIKit

protocol ArticleType {
    var title: String { get set}
    var url: String { get }
    var color: UIColor { get set }
}


/// tagでQiitaの記事を絞れます。tagのリストやtagのバリデータも作るべし
class Qiita: ArticleType {
    var title: String = "Qiita"
    var tag: String
    var url: String {
        get {
            "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fqiita.com%2Ftags%2F\(tag)%2Ffeed"
        }
    }
    var color: UIColor = .systemGreen
    init(tag: String) {
        self.tag = tag
    }
    
}
