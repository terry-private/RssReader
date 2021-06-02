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
    
    /// RssFeed記事を取得する関数
    static func fetch(urlString: String,
        // コールバック経由で、接続エラーか変換エラーか GitHubZen のいずれかを受け取れるようにする。
        _ block: @escaping (Either<Either<ConnectionError, TransformError>, Self>) -> Void
        
        // コールバックの引数の型が少しわかりづらいが、次の3パターンになる。
        //
        // - 接続エラーの場合     → .left(.left(ConnectionEither))
        // - 変換エラーの場合     → .left(.right(TransformError))
        // - 正常に取得できた場合 → .right(RssArticleList)
    ) {
        // URL が生成できない場合は不正な URL エラーを返す
        guard let url = URL(string: urlString) else {
            block(.left(.left(.malformedURL(debugInfo: urlString))))
            return
        }
        
        // RssFeedを取得するパラメータがないので入力は固定値になる。
        let input: Input = (
            url: url,
            queries: [],
            headers: [:],
            methodAndPayload: .get
        )
        
        // Alamofireの方の実装をしています。
        WebAPI.callByAF(with: input) { output in
            switch output {
            case let .noResponse(connectionError):
                // 接続エラーの場合は、接続エラーを渡す。
                block(.left(.left(connectionError)))
                
            case let .hasResponse(response):
                let errorOrZen = from(response: response)
                
                switch errorOrZen {
                case let .left(error):
                    block(.left(.right(error)))
                    
                case let .right(article):
                    block(.right(article))
                }
            }
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
