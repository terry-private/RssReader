//
//  RssClient.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/01/20.
//

import Foundation
import Alamofire

class RssClient {

    /// RSS記事の一覧を取得します。
    /// - Parameter rssApiUrl: https://rss2json.com/で作ったAPIのurl
    /// - Parameter completion: 完了時の処理　一旦全てのエラーでnilを返すだけの処理にしてます。
    /// URLSessionバージョン　こちらはテスト用
    class func fetchItems2(rssApiUrl: String, completion: @escaping ([Item]?) -> Void) {

        guard let url = URL(string: rssApiUrl) else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in

            if error != nil {
                completion(nil)
                return
            }

            guard let data = data else {
                completion(nil)
                return
            }

            let decoder = JSONDecoder()
            guard let articleList = try?decoder.decode(ArticleList.self, from: data) else {
                completion(nil)
                return
            }
            completion(articleList.items)
        })
        task.resume()
    }
    
    /// RSS記事の一覧を取得します。
    /// - Parameter rssApiUrl: https://rss2json.com/で作ったAPIのurl
    /// - Parameter completion: 完了時の処理　一旦全てのエラーでnilを返すだけの処理にしてます。
    /// alamofireバージョン　現在こちらが本番用
    class func fetchItems(rssApiUrl: String, completion: @escaping ([Item]?) -> Void) {
        
        let task = AF.request(rssApiUrl).responseJSON { response in
            switch response.result {
            case .success:
                do {
                    let decoder = JSONDecoder()
                    guard let data = response.data else {
                        completion(nil)
                        return
                    }
                    let articleList = try decoder.decode(ArticleList.self, from: data)
                    completion(articleList.items)
                } catch {
                    completion(nil)
                }
            case .failure(let error):
                print("error", error)
            }
        }
        task.resume()
    
    }
}
