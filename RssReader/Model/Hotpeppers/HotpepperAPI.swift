//
//  HotpepperAPI.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/05/27.
//

import Foundation

protocol HotpepperProtocol {
    associatedtype HotpepperError
    static func fetchRestaurants(latitude: Double, longitude: Double, completion: @escaping (Either<Either<ConnectionError, HotpepperError>, [Restaurant]>) -> Void)
}

enum HotpepperAPI: HotpepperProtocol {
    typealias HotpepperError = TransformError
    private var apiKey: String { "5362aa11cb87fd63" }
    private var baseURL: String { "http://webservice.recruit.co.jp/hotpepper/gourmet/v1/" }
    static func fetchRestaurants(latitude: Double, longitude: Double, completion: @escaping (Either<Either<ConnectionError, HotpepperError>, [Restaurant]>) -> Void) {
        
    }
    /// Hotpepper API の変換で起きうるエラーの一覧。
    enum TransformError {
        /// HTTP ステータスコードが OK 以外だった場合のエラー。
        case unexpectedStatusCode(debugInfo: String)
        
        /// ペイロードが壊れた文字列だった場合のエラー。
        case malformedData(debugInfo: String)
    }
}
