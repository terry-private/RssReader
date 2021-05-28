//
//  WebAPI.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/05/21.
//

import Foundation
import Alamofire

// MARK:- Input
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

// MARK:- Output
/// API の出力にをあらわす enum。
/// API の出力でありえるのは、
enum Output {
    /// レスポンスがある場合か、
    case hasResponse(Response)

    /// 通信エラーでレスポンスがない場合。
    case noResponse(ConnectionError)
}

/// 通信エラー。
enum ConnectionError {
    /// データまたはレスポンスが存在しない場合のエラー。
    case noDataOrNoResponse(debugInfo: String)
    
    /// 不正な URL の場合のエラー。
    case malformedURL(debugInfo: String)
}

/// API のレスポンス。構成要素は、以下の3つ。
typealias Response = (
    /// レスポンスの意味をあらわすステータスコード。
    statusCode: HTTPStatus,

    /// HTTP ヘッダー。
    headers: [String: String],

    /// レスポンスの本文。
    payload: Data
)

/// HTTPステータスコードを読みやすくする型。
enum HTTPStatus {
    /// OK の場合。HTTP ステータスコードでは 200 にあたる。
    case ok

    /// OK ではなかった場合の例。
    /// notFound の HTTP ステータスコードは 404 で、
    /// リクエストで要求された項目が存在しなかったことを意味する。
    case notFound

    /// 他にもステータスコードはあるが、全部定義するのは面倒なので、
    /// 必要ペースで定義できるようにする。
    case unsupported(code: Int)

    /// HTTP ステータスコードから HTTPステータス型を作る関数。
    static func from(code: Int) -> HTTPStatus {
        switch code {
        case 200:
            // 200 は OK の意味。
            return .ok
        case 404:
            // 404 は notFound の意味。
            return .notFound
        default:
            // それ以外はまだ対応しない。
            return .unsupported(code: code)
        }
    }
}

// MARK:- WebAPI
enum WebAPI {
    
    // MARK: - URLSessionを使った実装です。
    static func call(with input: Input, _ block: @escaping (Output) -> Void) {
        // URLSession へ渡す URLRequest を作成する。
        let urlRequest = self.createURLRequest(by: input)
        
        // レスポンス受信後のコールバックを登録する。
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, urlResponse, error) in
            
            // 受信したレスポンスまたは通信エラーを Output オブジェクトへ変換する。
            let output = self.createOutput(
                data: data,
                urlResponse: urlResponse as? HTTPURLResponse,
                error: error
            )
            
            // コールバックに Output オブジェクトを渡す。
            block(output)
        }
        task.resume()
    }
    
    // ビルドを通すために call 関数を用意しておく。
    static func call(with input: Input) {
        self.call(with: input) { _ in
            // NOTE: コールバック無しバージョンは一旦何もしない
        }
    }
    
    // Input から URLRequest を作成する関数。
    static private func createURLRequest(by input: Input) -> URLRequest {
        // クエリに対応させます。
        var urlComponents = URLComponents(string: input.url.absoluteString)!
        urlComponents.queryItems = input.queries
        
        // URL から URLRequest を作成する。
        var request = URLRequest(url: urlComponents.url!)
        // HTTP メソッドを設定する。
        request.httpMethod = input.methodAndPayload.method
        
        // リクエストの本文を設定する。
        request.httpBody = input.methodAndPayload.body
        
        // HTTP ヘッダを設定する。
        request.allHTTPHeaderFields = input.headers
        
        return request
    }
    
    // URLSession.dataTask のコールバック引数から Output オブジェクトを作成する関数。
    static private func createOutput(
        data: Data?,
        urlResponse: HTTPURLResponse?,
        error: Error?
    ) -> Output {
        // データと URLResponse がなければ通信エラー。
        guard let data = data, let response = urlResponse else {
            // エラーの内容を debugInfo に格納して通信エラーを返す。
            return .noResponse(.noDataOrNoResponse(debugInfo: error.debugDescription))
        }
        
        // HTTP ヘッダーを URLResponse から取り出して Output 型の
        // HTTP ヘッダーの型 [String: String] と一致するように変換する。
        var headers: [String: String] = [:]
        for (key, value) in response.allHeaderFields.enumerated() {
            headers[key.description] = String(describing: value)
        }
        
        // Output オブジェクトを作成して返す。
        return .hasResponse((
            // HTTP ステータスコードから HTTPStatus を作成する。
            statusCode: .from(code: response.statusCode),
            
            // 変換後の HTTP ヘッダーを返す。
            headers: headers,
            
            // レスポンスの本文をそのまま返す。
            payload: data
        ))
    }
    
    // MARK: - Alamofire製のcallByAF()を実装します。
    static func callByAF(with input: Input, _ block: @escaping (Output) -> Void) {
        
        let method = HTTPMethod(rawValue: input.methodAndPayload.method)
         
        let headers = HTTPHeaders(input.headers)
        
        
        AF.request(input.url, method: method, headers: headers).response { response in
            let output = createOutput(data: response.data, urlResponse: response.response, error: response.error)
            block(output)
        }.resume()
    }
    // ビルドを通すために callByAF 関数を用意しておく。
    static func callByAF(with input: Input) {
        self.call(with: input) { _ in
            // NOTE: コールバック無しバージョンは一旦何もしない
        }
    }
}
