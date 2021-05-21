//
//  RssAPI.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/05/21.
//

import Foundation

/// 既存のArticleList, Feed, Itemは利用して
/// Articleを書き換えます。一旦コピーします。
struct RssArticle {
    let item: Item
    let rssFeedTitle: String
    let rssFeedUrl: String
    let rssFeedFaviconUrl: String
    let tag: String
    var read: Bool = false
    var laterRead: Bool = false
    var isStar: Bool = false
    var sortKey: String {
        return rssFeedTitle + tag + (item.pubDate?.description ?? "") + item.link
    }
    /// レスポンスからわかりやすいオブジェクトへと変換する関数。
    ///
    /// ただし、サーバーがエラーを返してきた場合などは変換できないので、
    /// その場合はエラーを返す。つまり、戻り値はエラーがわかりやすいオブジェクトになる。
    /// このような、「どちらか」を意味する Either という型で表現する。
    /// Self が左でなく右なのは、正しいと Right をかけた慣例。
    static func from(response: Response) -> Either<TransformError, Self> {
        switch response.statusCode {
        case .ok:
            guard let title = String(data: response.payload, encoding: .utf8) else {
                // エンコード失敗の場合は.malformedDataとしてエラーメッセージを流す。
                return .left(.malformedData(debugInfo: "not UTF-8 String"))
            }
            let item = Item(title: title, pubDate: "", link: "", guid: "")
            return Either.right(RssArticle(item: item, rssFeedTitle: "", rssFeedUrl: "", rssFeedFaviconUrl: "", tag: ""))
        default:
            return Either.left(.unexpectedStatusCode(debugInfo: "\(response.statusCode)")
            )
        }
    }
    
    /// Rss API の変換で起きうるエラーの一覧。
    enum TransformError {
        /// HTTP ステータスコードが OK 以外だった場合のエラー。
        case unexpectedStatusCode(debugInfo: String)
        
        /// ペイロードが壊れた文字列だった場合のエラー。
        case malformedData(debugInfo: String)
    }
}
