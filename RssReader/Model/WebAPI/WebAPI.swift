//
//  WebAPI.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/05/21.
//

import Foundation

/// API への入力は Request そのもの。
typealias Input = Request


/// Request は以下の要素から構成される:
typealias Request = (
    /// リクエストの向き先の URL。
    url: URL,

    /// クエリ文字列。クエリは URLQueryItem という標準のクラスを使っている。
    queries: [URLQueryItem],

    /// HTTP ヘッダー。ヘッダー名と値の辞書になっている。
    headers: [String: String],

    /// HTTP メソッドとペイロードの組み合わせ。
    /// GET にはペイロードがなく、PUT や POST にはペイロードがあることを
    /// 表現するために、後述する enum を使っている。
    methodAndPayload: HTTPMethodAndPayload
)


/// HTTP メソッドとペイロードの組み合わせ。
enum HTTPMethodAndPayload {
    /// GET メソッドの定義。
    case get

    /// POST メソッドの定義（必要になるまでは省略）。
//    case post(payload: Data?)

    /// メソッドの文字列表現。
    var method: String {
        switch self {
        case .get:
            return "GET"
//        case .post:
//            return "POST"
        }
    }

    /// ペイロード。ペイロードがないメソッドの場合は nil。
    var body: Data? {
        switch self {
        case .get:
            // GET はペイロードを取れないので nil。
            return nil
//        case let .post(payload):
//            return payload
        }
    }
}

enum WebAPI {
    // ビルドを通すために call 関数を用意しておく。
    static func call(with input: Input) {
        // TODO: もう少しインターフェースが固まったら実装する。
    }
}
