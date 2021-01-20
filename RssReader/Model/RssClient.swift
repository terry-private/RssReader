//
//  RssClient.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/01/20.
//

import Foundation

class RssClient {

    /// RSS記事の一覧を取得します。
    /// - Parameter rssApiUrl: https://rss2json.com/で作ったAPIのurl
    /// - Parameter completion: 完了時の処理　一旦全てのエラーでnilを返すだけの処理にしてます。
    class func fetchItems(rssApiUrl: String, completion: @escaping ([Item]?) -> Void) {

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
}
