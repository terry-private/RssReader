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
    
    private static var apiKey: String { "5362aa11cb87fd63" }
    private static var baseURL: String { "http://webservice.recruit.co.jp/hotpepper/gourmet/v1/" }
    
    static func fetchRestaurants(latitude: Double, longitude: Double, completion: @escaping (Either<Either<ConnectionError, HotpepperError>, [Restaurant]>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.left(.left(.malformedURL(debugInfo: "\(baseURL) is not url"))))
            return
        }
        
        let input: Input = (
            url: url,
            queries: [
                URLQueryItem(name: "key", value: apiKey),
                URLQueryItem(name: "format", value: "json"),
                URLQueryItem(name: "lat", value: latitude.description),
                URLQueryItem(name: "lng", value: longitude.description),
                URLQueryItem(name: "range", value: "3"),
                URLQueryItem(name: "count", value: "20")
            ],
            headers: [:],
            methodAndPayload: .get
        )
        
        WebAPI.call(with: input) { output in
            switch output {
            case let .noResponse(connectionError):
                completion(.left(.left(connectionError)))
                
            case let .hasResponse(response):
                let errorOrRestaurants = decodeRestaurants(response: response)
                
                switch errorOrRestaurants {
                case let .left(error):
                    completion(.left(.right(error)))
                case let .right(restaurants):
                    completion(.right(restaurants))
                }
            }
        }
    }
    
    /// ResponseをEither<TransformError, [Restaurant]>に変換します。
    static func decodeRestaurants(response: Response) -> Either<TransformError, [Restaurant]>  {
        switch response.statusCode {
        case .ok:
            let decoder = JSONDecoder()
            guard let results = try? decoder.decode(RestaurantCodableObject.self, from: response.payload) else {
                return .left(.malformedData(debugInfo: "not UTF-8 String"))
            }
            
            return Either.right(results.results.shop.map { Restaurant.from($0)})
        default:
            return Either.left(.unexpectedStatusCode(debugInfo: "\(response.statusCode)"))
        }
    }

    /// Hotpepper API の変換で起きうるエラーの一覧。
    enum TransformError {
        /// HTTP ステータスコードが OK 以外だった場合のエラー。
        case unexpectedStatusCode(debugInfo: String)
        
        /// ペイロードが壊れた文字列だった場合のエラー。
        case malformedData(debugInfo: String)
    }
}
