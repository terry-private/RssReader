//
//  RssAPI.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/05/21.
//

import Foundation

/// 既存のFeed, Itemは利用して
/// ArticleListを書き換えます。一旦コピーします。
struct RssArticleList: Codable {
    let feed: Feed
    let items: [Item]
    /// レスポンスからわかりやすいオブジェクトへと変換する関数。
    ///
    /// ただし、サーバーがエラーを返してきた場合などは変換できないので、
    /// その場合はエラーを返す。つまり、戻り値はエラーがわかりやすいオブジェクトになる。
    /// このような、「どちらか」を意味する Either という型で表現する。
    /// Self が左でなく右なのは、正しいと Right をかけた慣例。
    static func from(response: Response) -> Either<TransformError, Self> {
        switch response.statusCode {
        case .ok:
            let decoder = JSONDecoder()
            guard let articleList = try? decoder.decode(RssArticleList.self, from: response.payload) else {
                return .left(.malformedData(debugInfo: "not UTF-8 String"))
            }
            return Either.right(articleList)
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
